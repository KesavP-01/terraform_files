import os
import sys
import logging
import re
import json
import pandas as pd
import datetime as dt
import pytz
#from pyspark.sql import SparkSession #
#from databricks.sdk.runtime import * #

"""
Overview
- Author: Oz / Tucker
- Version: 1.1

Excel functions:
- Configure json file with list of files / column type / etc.
- iterate through the files load
- rename columns and apply dtypes
- create spark dataframe
- create table

Pending improvements:
- drop any null column (e.g. x)
- unit test
- basic verification of data quality (e.g. number of rows??), sums, others?
- pyspark doesn't correctly interpret create_dttm?

"""

# -------------------------------------------------------------------------
# Logger Configuration
# Design notes:
#   - Creates a dta_ingetion.log file that can be set to different levels if we need to debug
#   - DEBUG:Detailed information meant for diagnosing issues during development or troubleshooting. typically turned off in production environments.
#   - INFO:Confirmation messages that everything is working as expected. 
#   - WARNING:An indication that something unexpected or concerning happened, but the software is still functioning.
#   - ERROR:A serious problem has occurred, indicating a failure in a part of the application. However, the program may still be able to continue running in a limited capacity.
#   - CRITICAL:A severe error that indicates the application itself may not be able to continue running. This typically precedes or accompanies a crash or a major outage.
# -------------------------------------------------------------------------
def configure_logger():
    logger = logging.getLogger("data_ingestion_logger")
    logger.setLevel(logging.DEBUG)  # Capture all levels at the logger

    formatter = logging.Formatter(
        fmt="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
        datefmt="%Y-%m-%d %H:%M:%S"
    )
    
    # Console Handler
    console_handler = logging.StreamHandler(sys.stdout)
    console_handler.setLevel(logging.INFO)  # Only INFO or above goes to console
    console_handler.setFormatter(formatter)
    logger.addHandler(console_handler)
    
    # File Handler
    file_handler = logging.FileHandler("data_ingestion.log", mode='a')
    file_handler.setLevel(logging.DEBUG)  # Capture all levels in the file
    file_handler.setFormatter(formatter)
    logger.addHandler(file_handler)
    
    return logger

# Create a global logger instance we can use throughout
logger = configure_logger()

# -------------------------------------------------------------------------
# Spark Session (if needed)
# -------------------------------------------------------------------------
# Typically in Databricks you already have a SparkSession 'spark' available,
# but if you need to create or retrieve one explicitly, do so:
# spark = SparkSession.builder \
#      .appName("DataIngestionApp") \
#      .getOrCreate()

# -------------------------------------------------------------------------
# Need to cleanup then name of the columns from Excel
# Design notes:
#    - Extracted as a separate function so that we can adjust as needed
# -------------------------------------------------------------------------
def fix_column_names(columns):
    """
    Fix column names to meet Databricks standards:
      - Add space to words with camel case (longer than 2 characters)
      - Remove any invalid characters
      - Convert to lowercase
      - Remove leading/trailing spaces
      - Remove extra spaces between words
      - Replace spaces with underscores
    """
    logger.debug("Fixing column names to meet Databricks standards.")
    fixed_cols = []
    for col in columns:
        # Add space to words with camel case (longer than 2 characters)
        col_fixed = re.sub(r'(?<!^)(?=[A-Z][a-z]{2,})', ' ', col)
        # replace % for percentage
        col_fixed = col_fixed.replace('%', 'percentage')
        # remove any character that is not alphanumeric or underscore or space
        col_fixed = re.sub(r'[^a-zA-Z0-9_\ ]', '', col_fixed)
        # lower, remove leading/trailing spaces
        col_fixed = col_fixed.strip('').lower()
        # remove extra spaces between words
        col_fixed = re.sub(r'\s+', ' ', col_fixed)
        # replace spaces with underscores
        col_fixed = col_fixed.replace(' ', '_')
        fixed_cols.append(col_fixed)

    logger.debug(f"Original columns: {list(columns)}")
    logger.debug(f"Fixed columns: {fixed_cols}")
    return fixed_cols

# -------------------------------------------------------------------------
# 3. Reads Excel or CSV file and converts to pandas dataframe
# Design note:
#   - Ended up reading everything as string to avoid type errors (weirdness coming from Excel)
#   - Intentionally left column_types as parameter here but it is ignored in the function
# -------------------------------------------------------------------------
def read_excel_or_csv(filename, worksheet=None, skiprows=0):
    """
    Reads an Excel or CSV file using pandas.
      - If `worksheet` is provided, attempts to read a specific sheet (Excel file).
      - If the file is .csv, `worksheet` will be ignored and the CSV is read directly.
      - skiprows can be used to skip initial rows.
    """
    logger.info(f"Reading file '{filename}', worksheet='{worksheet}', skiprows={skiprows}")
    ext = os.path.splitext(filename)[1].lower()
    try:
        if ext in ['.xlsx', '.xls']:
            # Read a specific worksheet (if provided) from an Excel file
            df = pd.read_excel(filename, sheet_name=worksheet, skiprows=skiprows, dtype=str)
            logger.debug(f"DataFrame read from Excel. Columns: {df.columns}")
        elif ext == '.csv':
            # Read CSV file
            df = pd.read_csv(filename, skiprows=skiprows, dtype=str)
            logger.debug(f"DataFrame read from CSV. Columns: {df.columns}")
        else:
            raise ValueError(f"Unsupported file extension: {ext}")
        return df
    except Exception as e:
        logger.exception(f"Error reading file '{filename}' with sheet '{worksheet}': {e}")
        raise RuntimeError(f"Error reading file '{filename}' with sheet '{worksheet}'") from e


# -------------------------------------------------------------------------
# 4. Takes the pandas dataframe and converts to specific data types as specified 
# in the config JSON
# -------------------------------------------------------------------------
def convert_to_expected_types(df, column_types={}):  # pragma: no cover
    """
    Converts the pandas DataFrame to the expected types given in the column_types dictionary from the config file.

    :param df: The pandas DataFrame to convert.
    :param column_types: A dictionary mapping column names or indices to their expected data types.
    :return: The DataFrame with converted data types.
    """
    logger.info("Converting columns to expected types.")

    for key, dtype_str in column_types.items():
        # Determine if input is using a column name or index
        if isinstance(key, str) and key in df.columns:
            col_name = key
        elif isinstance(key, int) and 0 <= key < len(df.columns):
            col_name = df.columns[key]
        else:
            logger.warning(f"Key '{key}' not found in DataFrame columns. Skipping conversion.")
            continue

        logger.debug(f"Converting column '{col_name}' to {dtype_str}.")
        try:
            if dtype_str in ("datetime", "date"):
                df.loc[:, col_name] = pd.to_datetime(df.loc[:, col_name], errors="coerce")
            elif dtype_str in ("int", "float"):
                df.loc[:, col_name] = pd.to_numeric(df.loc[:, col_name], errors="coerce")
            else:
                df.loc[:, col_name] = df.loc[:, col_name].astype(dtype_str, errors="ignore")
            logger.info(f"Successfully converted column '{col_name}' to {dtype_str}.")
        except Exception as e:
            logger.error(f"Failed to convert column '{col_name}' to {dtype_str}: {e}")

    return df


# def convert_to_expected_types_v1(df, column_types={}):
#     """
#     Converts the pandas DataFrame to the expected types given in the column_types dictionary from the config file.

#     :param df: The pandas DataFrame to convert.
#     :param column_types: A dictionary mapping column names to their expected data types.
#     :return: The DataFrame with converted data types.
#     """
#     logger.info("Converting columns to expected types.")

#     for col_name, dtype_str in column_types.items():
#         if col_name in df.columns:
#             logger.debug(f"Converting column '{col_name}' to {dtype_str}.")
#             try:
#                 if dtype_str in ("datetime", "date"):
#                     df[col_name] = pd.to_datetime(df[col_name], errors="coerce")
#                 elif dtype_str in ("int", "float"):
#                     df[col_name] = pd.to_numeric(df[col_name], errors="coerce")
#                 else:
#                     df[col_name] = df[col_name].astype(dtype_str, errors="ignore")
#                 logger.info(f"Successfully converted column '{col_name}' to {dtype_str}.")
#             except Exception as e:
#                 logger.error(f"Failed to convert column '{col_name}' to {dtype_str}: {e}")
#         else:
#             logger.warning(f"Column '{col_name}' not found in DataFrame. Skipping conversion.")

#     return df

# -------------------------------------------------------------------------
# 2. Main Processing Functions for each individual file
# -------------------------------------------------------------------------
def process_file(config_entry):
    """
    config_entry = Json configurationfile
    Steps:
      1. Read each worksheet (or CSV) from the file
      2. Clean columns (standard naming)
      3. Add a 'source_file' column
      4. Basic cleanup (fillna(0))
      5. Create Spark DataFrame
      6. Write to Databricks table
    """
    #volume = config_entry.get("volume")
    filename = config_entry.get("filename")
    worksheets_info = config_entry.get("worksheets", [])

    if not filename or not worksheets_info:
        logger.error("Config entry must contain 'filename' and a non-empty 'worksheets' list.")
        raise ValueError("Config entry must contain 'filename' and a non-empty 'worksheets' list.")

    for sheet_info in worksheets_info:
        # worksheet = sheet_info.get("worksheet", None)
        worksheet = sheet_info.get("worksheet", 0) # changed default to 0 which is recognized by read_excel
        skiprows = sheet_info.get("skiprows", 0)
        table_name = sheet_info.get("table_name")
        column_types = sheet_info.get("column_types", {})

        if not table_name:
            logger.error("Each worksheet info dict must include a 'table_name'.")
            raise ValueError("Each worksheet info dict must include a 'table_name'.")

        logger.info(
            f"Processing file='{filename}', worksheet='{worksheet}', "
            f"skiprows={skiprows}, table='{table_name}', column_types={column_types}"
        )

        # 1) Read data into a pandas DataFrame
        df = read_excel_or_csv(
            filename,
            worksheet=worksheet,
            skiprows=skiprows
        )

        # 2) Convert columns to expected types
        df = convert_to_expected_types(df, column_types=column_types)
        logger.debug(f"DataFrame dtypes after conversion:\n{df.dtypes}")

        # 3) Fix column names
        df.columns = fix_column_names(df.columns)

        # 4) Add 'source_file' and dttm column
        df['source_file'] = os.path.basename(filename)
        df['create_dttm'] = pd.to_datetime(dt.datetime.now(pytz.timezone('US/Pacific')))
        df['modify_dttm'] = pd.to_datetime(dt.datetime.now(pytz.timezone('US/Pacific')))

        # 5) Basic cleanup (fillna(0))
        # This could be extracted to a separate function if we find the need for it
        df.fillna(0, inplace=True)

        # For debugging in a notebook environment, you might show a sample:
        logger.debug(f"Sample data:\n{df.head(15)}")

        # 6) Convert to Spark DataFrame
        try:
            spark_df = spark.createDataFrame(df)
        except Exception as e:
            logger.exception(f"Error creating Spark DataFrame for '{filename}', worksheet '{worksheet}': {e}")
            raise RuntimeError(f"Error creating Spark DataFrame for file '{filename}' worksheet '{worksheet}'") from e

        # 7) Write to Databricks table
        logger.info(f"Writing to Databricks table: {table_name}")
        try:
            spark.sql(f"DROP TABLE IF EXISTS {table_name}")
            spark_df.write.format("delta").mode("overwrite") \
                .option("mergeSchema", "true") \
                .saveAsTable(table_name)
            logger.info(f"Successfully wrote data to table: {table_name}")
        except Exception as e:
            logger.exception(f"Failed to write to table '{table_name}': {e}")
            raise RuntimeError(f"Failed to write to table '{table_name}'") from e


# -----------------------------------------------------------------
# Step 1: Called from main. Iterates over the list of files passed on the JSON
# ---------------------------------------------------------------------------
def process_files(config_json):
    """
    Main function to process multiple files based on the provided JSON-like config.
    """
    if isinstance(config_json, str):
        config_data = json.loads(config_json)
    else:
        config_data = config_json

    files_list = config_data.get("files", [])
    if not files_list:
        logger.error("No 'files' key found in provided config JSON.")
        raise ValueError("No 'files' key found in provided config JSON.")

    for entry in files_list:
        process_file(entry)


def get_latest_file(volume_path):  # pragma: no cover
    """
    Retrieves the last created file in the specified volume.

    :param volume_path: Path to the volume where files are stored.
    :return: The path to the latest created file.
    """
    try:
        files = [os.path.join(volume_path, f) for f in os.listdir(volume_path) if os.path.isfile(os.path.join(volume_path, f))]
        latest_file = max(files, key=os.path.getctime)
        return latest_file
    except Exception as e:
        logger.exception(f"Error retrieving the latest file from volume '{volume_path}': {e}")
        raise RuntimeError(f"Error retrieving the latest file from volume '{volume_path}'") from e


def edw_pull(sql:str, numPartitions:int = 8, fetchsize:int = 10000):  # pragma: no cover
    """
    Pulls data from Oracle to Databricks.

    Args:
        sql: The SQL query to execute.
        fetchsize: The JDBC fetch size.
        NOT USED: num_partitions: The number of partitions for the DataFrame.

    Returns:
        A Spark DataFrame.
    """
    import logging

    try:
        # Retrieve secrets.  Embeds credentials so they are consistent in workflows.  If credentials change, they only need to be updated here and not in each individual workflow.
        un = dbutils.secrets.get(scope="CommercialAnalytics", key="edw-commarsa")
        pw = dbutils.secrets.get(scope="CommercialAnalytics", key="edw-commarsa-pw")
    except Exception as e:
        logging.error(f"Failed to retrieve secrets: {e}")
        raise

    df = (
        spark.read.format("jdbc")
        .option("url", "jdbc:oracle:thin:@reporting.datawarehouse.db.insideaag.com:1522/edwprod")
        .option("user", un)
        .option("password", pw)
        .option("query", sql)
        .option("driver", "oracle.jdbc.driver.OracleDriver")
        .option("fetchsize", fetchsize) # default is 10
        .option("numPartitions", numPartitions) # max of 8 for oracle
        # partitionColumn, lowerBound, upperBound
        .load()
    )
    # display(df)
    return df
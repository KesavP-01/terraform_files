# tests/unit/test_file_reading.py (or add to an existing test file)

import pytest
import pandas as pd
from pandas.testing import assert_frame_equal
from unittest.mock import patch, MagicMock
import os # Only needed if you were to use os constants, not for this test directly.

# Assuming your read_excel_or_csv function and global logger are in 'src.functions'
from src.functions import read_excel_or_csv #, logger (if you need to assert logger calls)

DUMMY_FILENAME = "test_file" # Base name, extension will be controlled by mock
DUMMY_WORKSHEET = "Sheet1"
DUMMY_SKIPROWS = 5

# Sample DataFrame to be returned by mocks
@pytest.fixture
def mock_dataframe():
    return pd.DataFrame({'col1': [1, 2], 'col2': ['A', 'B']})

# Use @patch as decorators on the test functions, or as context managers within them.
# Patching them where they are looked up (in 'src.functions' if that's where pd/os are imported and used)

@patch('src.functions.pd.read_csv')
@patch('src.functions.os.path.splitext')
def test_read_csv_success(mock_splitext, mock_read_csv, mock_dataframe):
    """Test successful reading of a CSV file."""
    mock_splitext.return_value = (DUMMY_FILENAME, '.csv')
    mock_read_csv.return_value = mock_dataframe

    df_result = read_excel_or_csv(f"{DUMMY_FILENAME}.csv", skiprows=DUMMY_SKIPROWS)

    mock_splitext.assert_called_once_with(f"{DUMMY_FILENAME}.csv")
    mock_read_csv.assert_called_once_with(
        f"{DUMMY_FILENAME}.csv",
        skiprows=DUMMY_SKIPROWS,
        dtype=str
    )
    assert_frame_equal(df_result, mock_dataframe)

@patch('src.functions.pd.read_excel')
@patch('src.functions.os.path.splitext')
def test_read_xlsx_success(mock_splitext, mock_read_excel, mock_dataframe):
    """Test successful reading of an XLSX file."""
    mock_splitext.return_value = (DUMMY_FILENAME, '.xlsx')
    mock_read_excel.return_value = mock_dataframe

    df_result = read_excel_or_csv(
        f"{DUMMY_FILENAME}.xlsx",
        worksheet=DUMMY_WORKSHEET,
        skiprows=DUMMY_SKIPROWS
    )

    mock_splitext.assert_called_once_with(f"{DUMMY_FILENAME}.xlsx")
    mock_read_excel.assert_called_once_with(
        f"{DUMMY_FILENAME}.xlsx",
        sheet_name=DUMMY_WORKSHEET,
        skiprows=DUMMY_SKIPROWS,
        dtype=str
    )
    assert_frame_equal(df_result, mock_dataframe)

@patch('src.functions.pd.read_excel')
@patch('src.functions.os.path.splitext')
def test_read_xls_success(mock_splitext, mock_read_excel, mock_dataframe):
    """Test successful reading of an XLS file."""
    mock_splitext.return_value = (DUMMY_FILENAME, '.xls')
    mock_read_excel.return_value = mock_dataframe

    df_result = read_excel_or_csv(f"{DUMMY_FILENAME}.xls") 

    mock_splitext.assert_called_once_with(f"{DUMMY_FILENAME}.xls")
    mock_read_excel.assert_called_once_with(
        f"{DUMMY_FILENAME}.xls",
        sheet_name=None, # Default
        skiprows=0,      # Default
        dtype=str
    )
    assert_frame_equal(df_result, mock_dataframe)


@patch('src.functions.pd.read_excel', side_effect=Exception("Generic pandas failure"))
@patch('src.functions.os.path.splitext')
def test_read_excel_generic_exception(mock_splitext, mock_read_excel_generic_exc, caplog):
    """Test handling of a generic Exception from pandas read functions."""
    mock_splitext.return_value = (DUMMY_FILENAME, '.xls') 

    with pytest.raises(RuntimeError) as excinfo:
        read_excel_or_csv(f"{DUMMY_FILENAME}.xls")

    assert f"Error reading file '{DUMMY_FILENAME}.xls'" in str(excinfo.value)
    assert "Generic pandas failure" in str(excinfo.value.__cause__)

    expected_log_message = f"Error reading file '{DUMMY_FILENAME}.xls' with sheet 'None': Generic pandas failure"
    assert expected_log_message in caplog.text
    
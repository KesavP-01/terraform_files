# tests/unit/test_process_file_simplified.py

import pytest
import pandas as pd
from unittest.mock import patch, MagicMock, call # call for checking multiple calls if needed
import datetime as dt # For when we mock pd.to_datetime

# Assuming functions are in src.functions
from databricks_asset_bundle.shared_libs.common_utils_lib.src.functions import process_file
# We also need to import the specific functions we intend to mock if they are in the same module
# or ensure the patch path is correct.

@pytest.fixture
def sample_config_entry():
    """Provides a valid sample config_entry for one sheet."""
    return {
        "filename": "test_data.xlsx",
        "worksheets": [
            {
                "worksheet": "Sheet1",
                "skiprows": 1,
                "table_name": "target_table_1",
                "column_types": {"colA": "int", "colB": "str"}
            }
        ]
    }

def test_process_file_missing_filename(caplog):
    """Test error handling when filename is missing."""
    config_entry = {
        # "filename": "test.xlsx", # Missing
        "worksheets": [{"table_name": "some_table"}]
    }
    with pytest.raises(ValueError, match="Config entry must contain 'filename' and a non-empty 'worksheets' list."):
        process_file(config_entry)
    assert "Config entry must contain 'filename' and a non-empty 'worksheets' list." in caplog.text

def test_process_file_empty_worksheets_info(caplog):
    """Test error handling when worksheets_info is empty."""
    config_entry = {
        "filename": "test.xlsx",
        "worksheets": [] # Empty list
    }
    with pytest.raises(ValueError, match="Config entry must contain 'filename' and a non-empty 'worksheets' list."):
        process_file(config_entry)
    assert "Config entry must contain 'filename' and a non-empty 'worksheets' list." in caplog.text

def test_process_file_missing_table_name_in_sheet_info(caplog):
    """Test error handling when table_name is missing in one of the sheet_info dicts."""
    config_entry = {
        "filename": "test.xlsx",
        "worksheets": [
            {"worksheet": "Sheet1", "column_types": {}}, # Missing table_name
            {"worksheet": "Sheet2", "table_name": "table2", "column_types": {}}
        ]
    }
    # This test will fail if process_file stops at the first error.
    # The loop will try to process the first sheet, fail, and raise ValueError.
    # It won't get to the second sheet.
    with pytest.raises(ValueError, match="Each worksheet info dict must include a 'table_name'."):
        process_file(config_entry)
    assert "Each worksheet info dict must include a 'table_name'." in caplog.text
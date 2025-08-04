# tests/unit/test_process_files.py (or add to an existing test file)

import pytest
import json
from unittest.mock import patch, call # call is useful for checking arguments of multiple calls

# Assuming your process_files and global logger are in 'src.functions'
# Ensure the logger is available if process_files uses it directly for errors before calling process_file
# (e.g., by importing the configured logger from src.functions)
from databricks_asset_bundle.shared_libs.common_utils_lib.src.functions import process_files #, logger (if needed for asserting logger calls within process_files itself)

# Sample valid config entries that process_file would expect
SAMPLE_CONFIG_ENTRY_1 = {"filename": "file1.xlsx", "worksheets": [{"table_name": "table1"}]}
SAMPLE_CONFIG_ENTRY_2 = {"filename": "file2.csv", "worksheets": [{"table_name": "table2"}]}

@patch('src.functions.process_file') # Mock the main dependency
def test_process_files_with_valid_json_string(mock_process_file):
    """Test with a valid JSON string input."""
    config_json_str = json.dumps({
        "files": [SAMPLE_CONFIG_ENTRY_1, SAMPLE_CONFIG_ENTRY_2]
    })
    process_files(config_json_str)

    assert mock_process_file.call_count == 2
    mock_process_file.assert_has_calls([
        call(SAMPLE_CONFIG_ENTRY_1),
        call(SAMPLE_CONFIG_ENTRY_2)
    ], any_order=False) # Assuming order matters, or True if it doesn't

@patch('src.functions.process_file')
def test_process_files_with_valid_dict_input(mock_process_file):
    """Test with a valid dictionary input."""
    config_dict = {
        "files": [SAMPLE_CONFIG_ENTRY_1]
    }
    process_files(config_dict)

    mock_process_file.assert_called_once_with(SAMPLE_CONFIG_ENTRY_1)

@patch('src.functions.process_file') # Mock to prevent its execution
def test_process_files_missing_files_key(mock_process_file, caplog):
    """Test when the 'files' key is missing in the config."""
    config_dict_no_files_key = {"other_key": "value"}
    with pytest.raises(ValueError) as excinfo:
        process_files(config_dict_no_files_key)
    
    assert "No 'files' key found" in str(excinfo.value)
    # from src.functions import logger # If you want to assert log content
    # assert "No 'files' key found" in caplog.text
    mock_process_file.assert_not_called()


@patch('src.functions.process_file')
def test_process_files_single_file_entry(mock_process_file):
    """Test processing a single file entry."""
    config_dict = {"files": [SAMPLE_CONFIG_ENTRY_1]}
    process_files(config_dict)
    
    mock_process_file.assert_called_once_with(SAMPLE_CONFIG_ENTRY_1)

@patch('src.functions.process_file')
def test_process_files_multiple_file_entries_order(mock_process_file):
    """Test that process_file is called for each entry in order."""
    config_dict = {"files": [SAMPLE_CONFIG_ENTRY_1, SAMPLE_CONFIG_ENTRY_2]}
    process_files(config_dict)
    
    expected_calls = [call(SAMPLE_CONFIG_ENTRY_1), call(SAMPLE_CONFIG_ENTRY_2)]
    mock_process_file.assert_has_calls(expected_calls, any_order=False)
    assert mock_process_file.call_count == len(expected_calls)

# Optional: Test if process_file raising an error stops process_files or not
# Current process_files design would stop if process_file raises an unhandled error.
# If process_files is meant to continue on error for other files, that's a different test.

@patch('src.functions.process_file')
def test_process_files_continues_if_process_file_raises_and_is_handled_within_loop(mock_process_file):
    """
    This test assumes process_files itself would have a try-except around calling process_file
    if it's meant to continue processing other files when one fails.
    Your current process_files does NOT have such a try-except.
    If process_file raises an error, process_files will stop.
    So, this test as written would fail unless process_files is modified.
    Let's test the current behavior: an error in process_file stops everything.
    """
    config_dict = {
        "files": [SAMPLE_CONFIG_ENTRY_1, {"bad_entry": "will_fail"}, SAMPLE_CONFIG_ENTRY_2]
    }
    # Simulate process_file raising an error on the second call
    mock_process_file.side_effect = [
        None, # First call for SAMPLE_CONFIG_ENTRY_1 succeeds
        RuntimeError("Failed processing bad_entry"), # Second call fails
        None  # This won't be reached
    ]
    
    with pytest.raises(RuntimeError, match="Failed processing bad_entry"):
        process_files(config_dict)
        
    # Check calls: process_file was called for the first and second entries
    # but not the third because the loop broke.
    mock_process_file.assert_has_calls([
        call(SAMPLE_CONFIG_ENTRY_1),
        call({"bad_entry": "will_fail"})
    ], any_order=False)
    assert mock_process_file.call_count == 2
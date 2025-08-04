import pytest
from databricks_asset_bundle.shared_libs.common_utils_lib.src.functions import fix_column_names, configure_logger

# Configure a logger for tests if your function relies on it being initialized.
# You might want to mock or disable extensive logging during tests for cleaner output.
# For simplicity here, we'll just initialize it.
logger = configure_logger()

def test_fix_column_names_simple():
    """Test basic column name fixing."""
    input_columns = ["FirstName", "LastName", "EmailAddress"]
    expected_output = ["first_name", "last_name", "email_address"]
    assert fix_column_names(input_columns) == expected_output

def test_fix_column_names_with_invalid_chars():
    """Test removal of invalid characters."""
    input_columns = [ "My-Column", "Test (Special)"]
    expected_output = [ "my_column", "test_special"]
    assert fix_column_names(input_columns) == expected_output

def test_fix_column_names_camel_case_short_words():
    """Test camel case handling with short words (should not split)."""
    input_columns = ["ABTest", "CDrive"] 
    expected_output = ["ab_test", "c_drive"]
    assert fix_column_names(input_columns) == expected_output

def test_fix_column_names_camel_case_longer_words():
    """Test camel case handling with longer words."""
    input_columns = [ "AnotherLongerWordExample"]
    expected_output = [ "another_longer_word_example"]
    assert fix_column_names(input_columns) == expected_output

def test_fix_column_names_empty_and_existing_underscores():
    """Test with empty list and columns that already have underscores or are fine."""
    input_columns = ["already_correct", "Has Space"]
    expected_output = ["already_correct", "has_space"]
    assert fix_column_names(input_columns) == expected_output

    input_columns_empty = []
    expected_output_empty = []
    assert fix_column_names(input_columns_empty) == expected_output_empty

def test_fix_column_names_leading_trailing_underscores_and_numbers():
    """Test columns with leading/trailing underscores or numbers."""
    input_columns = ["_leading_underscore", "trailing_underscore_", "column123", "123column"]
    expected_output = ["_leading_underscore", "trailing_underscore_", "column123", "123column"] # Current logic keeps these as is after stripping spaces
    assert fix_column_names(input_columns) == expected_output
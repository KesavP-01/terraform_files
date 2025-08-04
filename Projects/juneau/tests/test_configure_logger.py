# tests/unit/test_logger_config.py (or your chosen test file)

import pytest
import logging
import sys
from unittest.mock import patch, MagicMock

# Assuming your configure_logger function is in 'src.functions'
from databricks_asset_bundle.shared_libs.common_utils_lib.src.functions import configure_logger

EXPECTED_LOGGER_NAME = "data_ingestion_logger"
EXPECTED_LOG_FORMAT = "%(asctime)s - %(name)s - %(levelname)s - %(message)s"
EXPECTED_DATE_FORMAT = "%Y-%m-%d %H:%M:%S"
EXPECTED_LOG_FILE_NAME = "data_ingestion.log"

@pytest.fixture
def isolated_data_ingestion_logger(mocker):
    """
    Provides a configured logger instance from configure_logger.
    It ensures the specific logger "data_ingestion_logger" is cleaned before and after the test
    to prevent state leakage. Mocks FileHandler.
    """
    # Get the specific logger instance by its expected name
    logger_instance = logging.getLogger(EXPECTED_LOGGER_NAME)

    # --- Setup: Clean state before test ---
    # Remove any handlers that might have been added by previous tests or module imports
    logger_instance.handlers.clear()
    # Reset level, so configure_logger's setLevel is effective
    logger_instance.setLevel(logging.NOTSET)
    # Ensure propagation is not inadvertently stopped by a previous test if it's relevant
    logger_instance.propagate = True

    # Mock logging.FileHandler for the duration of this test
    mock_file_handler_instance = MagicMock(spec=logging.FileHandler)
    # Patch logging.FileHandler in the 'logging' module (where configure_logger will look for it)
    mocker.patch('logging.FileHandler', return_value=mock_file_handler_instance)
    
    # Call the function under test
    configured_log = configure_logger()
    
    yield configured_log  # Provide the configured logger to the test
    
    # --- Teardown: Clean state after test ---
    # This is crucial to prevent this test from affecting subsequent tests
    logger_instance.handlers.clear()
    logger_instance.setLevel(logging.NOTSET)
    logger_instance.propagate = True
    # Removing the logger from the manager can be risky if other parts of the system
    # expect it to exist. Clearing handlers and resetting level is usually safer.
    # if EXPECTED_LOGGER_NAME in logging.Logger.manager.loggerDict:
    #     del logging.Logger.manager.loggerDict[EXPECTED_LOGGER_NAME]

# --- Tests using the isolated_data_ingestion_logger fixture ---

def test_configure_logger_returns_logger_instance(isolated_data_ingestion_logger):
    assert isinstance(isolated_data_ingestion_logger, logging.Logger)

def test_configure_logger_name(isolated_data_ingestion_logger):
    assert isolated_data_ingestion_logger.name == EXPECTED_LOGGER_NAME

def test_configure_logger_level(isolated_data_ingestion_logger):
    assert isolated_data_ingestion_logger.level == logging.DEBUG

def test_configure_logger_has_correct_number_of_handlers(isolated_data_ingestion_logger):
    # The fixture ensures handlers are cleared before configure_logger is called for this test
    assert len(isolated_data_ingestion_logger.handlers) == 2, \
        f"Expected 2 handlers, got {len(isolated_data_ingestion_logger.handlers)}. Handlers: {isolated_data_ingestion_logger.handlers}"

def test_configure_logger_console_handler_properties(isolated_data_ingestion_logger):
    console_handler = None
    for handler in isolated_data_ingestion_logger.handlers:
        if isinstance(handler, logging.StreamHandler) and handler.stream == sys.stdout:
            console_handler = handler
            break
    
    assert console_handler is not None, "Console handler (StreamHandler for sys.stdout) not found."
    assert console_handler.level == logging.INFO, "Console handler level should be INFO."
    assert isinstance(console_handler.formatter, logging.Formatter)
    assert console_handler.formatter._fmt == EXPECTED_LOG_FORMAT
    assert console_handler.formatter.datefmt == EXPECTED_DATE_FORMAT
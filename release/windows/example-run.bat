@echo off

set lib_path=%CD%\lib

set config_path=%CD%\example_config.toml

cd %lib_path%
run_bot.bat %config_path%
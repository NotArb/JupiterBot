#!/bin/bash

# Define lib path
lib_path=$(dirname "${BASH_SOURCE[0]}")

# Remove trailing slash from lib path if it exists
lib_path="${lib_path%/}"

# Set BOT_PATH to default path if not defined
if [ -z "$BOT_PATH" ]; then
    # This default path is auto-generated by our release task
    BOT_PATH="$lib_path/../../NotArbBot-0.0.1-alpha"
fi

# Ensure BOT_PATH file exists
if [ ! -f "$BOT_PATH" ]; then
    echo "Error: BOT_PATH file does not exist"
    exit 1
fi

# Ensure CONFIG_PATH is defined
if [ -z "$CONFIG_PATH" ]; then
    echo "Error: CONFIG_PATH not defined"
    exit 1
fi

# Ensure CONFIG_PATH file exists
if [ ! -f "$CONFIG_PATH" ]; then
    echo "Error: CONFIG_PATH file does not exist"
    echo "$CONFIG_PATH"
    exit 1
fi

# Java exe check
if [ -z "$JAVA_EXE_PATH" ]; then
    # Attempt to install Java if necessary
    . "$lib_path/install_java.sh"
else
    echo "$JAVA_EXE_PATH"
    "$JAVA_EXE_PATH" --version
    if [ $? -ne 0 ]; then
        echo "Warning: Java could not be verified."
    fi
fi

# Java vm_args check
if [ -z "$1" ]; then
    echo "Warning: No vm_args set, this is not advised."
else
    echo "vm_args=$*"
fi

# Misc debug
echo "BOT_PATH=$BOT_PATH"
echo "CONFIG_PATH=$CONFIG_PATH"

# Run bot
"$JAVA_EXE_PATH" "$@" -DCALLER_SCRIPT_DIR="$(pwd)" -cp "$BOT_PATH" org.notarb.launcher.Main "$CONFIG_PATH"
echo "Bot exited with code $?"
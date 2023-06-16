#!/usr/bin/bash

# Find latest Android SDK tools package and NDK versions
ANDROID_SDK_TOOLS_VERSION=$(curl https://developer.android.com/studio | grep -oP 'commandlinetools-linux-\K\d+.\d+.\d+' | head -1)

# Print versions
echo "ANDROID_SDK_TOOLS_VERSION: $ANDROID_SDK_TOOLS_VERSION"

# Check if Android SDK tools is already installed
if [ -d "$HOME/Android/Sdk/cmdline-tools" ]; then
    echo "Android SDK tools is already installed"
    # Ask user if they want to reinstall Android SDK tools
    read -p "Do you want to reinstall Android SDK tools? (y/n): " REINSTALL
    if [ "$REINSTALL" = "y" ]; then
        echo "Reinstalling Android SDK tools..."
        # Remove Android SDK tools
        rm -rf $HOME/Android/Sdk/cmdline-tools
    else
        echo "Skipping Android SDK tools installation"
    fi
fi

# Check if Android SDK tools zip file is already downloaded in current directory
if [ -f "commandlinetools-linux-${ANDROID_SDK_TOOLS_VERSION}_latest.zip" ]; then
    echo "Android SDK tools zip file is already downloaded in current directory"
else
    echo "Downloading Android SDK tools zip file..."
    # Download Android SDK tools
    wget https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_SDK_TOOLS_VERSION}_latest.zip
fi

# Unzip Android SDK tools
unzip commandlinetools-linux-${ANDROID_SDK_TOOLS_VERSION}_latest.zip

# Remove zip file after unzipping
rm commandlinetools-linux-${ANDROID_SDK_TOOLS_VERSION}_latest.zip

# Create Android SDK directory
mkdir -p $HOME/Android/Sdk
export ANDROID_SDK_ROOT=$HOME/Android/Sdk
# update .bashrc with ANDROID_SDK_ROOT if not already added
if ! grep -q "ANDROID_SDK_ROOT" $HOME/.bashrc; then
    # Update .bashrc with ANDROID_SDK_ROOT
    sed -i '$ a export ANDROID_SDK_ROOT=$HOME/Android/Sdk' $HOME/.bashrc
fi

# Move Android SDK tools to Android SDK directory
mv cmdline-tools $HOME/Android/Sdk

# Update PATH if not already updated
if ! grep -q "$ANDROID_SDK_ROOT/cmdline-tools/tools/bin" $HOME/.bashrc; then
    # Update .bashrc with Android SDK tools PATH appended
    sed -i '$ a export PATH=$PATH:$ANDROID_SDK_ROOT/cmdline-tools/tools/bin' $HOME/.bashrc
fi

# Update source
source $HOME/.bashrc

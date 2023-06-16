#!/usr/bin/bash

sdkmanager=$ANDROID_SDK_ROOT/cmdline-tools/bin/sdkmanager

# Find latest Android NDK version
ANDROID_NDK_VERSION=$(curl https://developer.android.com/ndk/downloads | grep -oP 'android-ndk-r\K\d+[a-z]' | head -1)

# Check if Android SDK tools is already installed
if [ -d "$HOME/Android/Sdk/ndk" ]; then
    echo "Android NDK is already installed"
    # ask user if they want to reinstall
    read -p "Do you want to reinstall Android NDK? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Reinstalling Android NDK..."
        # Remove Android NDK
        rm -rf $HOME/Android/Sdk/ndk
    else
        echo "Skipping Android NDK installation"
        exit 0
    fi
fi

# Check if Android NDK zip file is already downloaded in current directory
if [ -f "android-ndk-${ANDROID_NDK_VERSION}-linux.zip" ]; then
    echo "Android NDK zip file is already downloaded in current directory"
else
    echo "Downloading Android NDK zip file..."
    # Download Android NDK
    wget https://dl.google.com/android/repository/android-ndk-r${ANDROID_NDK_VERSION}-linux.zip
fi

# Unzip Android NDK
unzip android-ndk-r${ANDROID_NDK_VERSION}-linux.zip

# Remove zip file after unzipping
rm android-ndk-r${ANDROID_NDK_VERSION}-linux.zip

# Move Android NDK to Android SDK directory
mv android-ndk-r${ANDROID_NDK_VERSION} $HOME/Android/Sdk/ndk

# Add ANDROID_NDK_ROOT if not already present
if ! grep -q "ANDROID_NDK_ROOT" $HOME/.bashrc; then
    sed -i '$ a export ANDROID_NDK_ROOT=$ANDROID_SDK_ROOT/ndk' $HOME/.bashrc
    sed -i '$ a export PATH=$PATH:$ANDROID_NDK_ROOT' $HOME/.bashrc
fi

# Update source
source $HOME/.bashrc

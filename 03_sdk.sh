#!/usr/bin/bash

sdkmanager=$ANDROID_SDK_ROOT/cmdline-tools/bin/sdkmanager

# Update SDK Manager ($ANDROID_SDK_ROOT/cmdline-tools/bin/sdkmanager) to latest version
yes | $sdkmanager --sdk_root=$HOME/Android/Sdk/cmdline-tools --update

# Fetch latest build tools, platforms and platform tools versions
PLATFORM_VERSION_NUMBER=$($sdkmanager --sdk_root=$HOME/Android/Sdk/cmdline-tools --list | grep -oP 'platforms;android-\K\d+' | sort -V | uniq | tail -2 | head -1)
# android-xx
PLATFORM_VERSION="android-$PLATFORM_VERSION_NUMBER"
# xx.x.x
BUILD_TOOLS_VERSION=$($sdkmanager --sdk_root=$HOME/Android/Sdk/cmdline-tools --list | grep -oP "build-tools;\K$PLATFORM_VERSION_NUMBER.\d+.\d+" | sort -V | uniq | tail -1)

# Install Android SDK platforms, build tools and platform tools (accept licenses) api 29
yes | $sdkmanager --sdk_root=$HOME/Android/Sdk/cmdline-tools "platform-tools" "platforms;$PLATFORM_VERSION" "build-tools;$BUILD_TOOLS_VERSION"

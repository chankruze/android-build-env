#!/usr/bin/bash

# if java command is not found, install Java
if ! java -version &>/dev/null; then
    echo "Java is not installed"
    # List all Java packages and find the highest version number
    java_packages=$(apt-cache search openjdk | grep -oP 'openjdk-\K\d+')
    latest_java=$(echo "$java_packages" | sort -V | tail -1)
    # Print latest Java version
    echo "latest_java: $latest_java"
    # Install Java
    sudo apt-get install -y "openjdk-$latest_java-jdk"
    # export JAVA_HOME
    export JAVA_HOME=/usr/lib/jvm/java-$latest_java-openjdk-amd64
    # Add JAVA_HOME to .bashrc if not already added
    if ! grep -q "export JAVA_HOME=/usr/lib/jvm/java-$latest_java-openjdk-amd64" $HOME/.bashrc; then
        echo "export JAVA_HOME=/usr/lib/jvm/java-$latest_java-openjdk-amd64" >>$HOME/.bashrc
    fi
    # Add Java to PATH
    export PATH=$PATH:$JAVA_HOME/bin
    # Update source
    source $HOME/.bashrc
fi

# Check if Java is already installed (java -version returns exit code 0)
if java -version &>/dev/null; then
    echo "Java is already installed"
    # Ask user if they want to reinstall Java
    read -p "Do you want to reinstall Java? (y/n): " REINSTALL
    if [ "$REINSTALL" = "y" ]; then
        echo "Reinstalling Java..."
        # Remove Java
        sudo apt-get purge -y openjdk-\*
        # List all Java packages and find the highest version number
        java_packages=$(apt-cache search openjdk | grep -oP 'openjdk-\K\d+')
        latest_java=$(echo "$java_packages" | sort -V | tail -1)
        # Print latest Java version
        echo "latest_java: $latest_java"
        # Install Java
        sudo apt-get install -y "openjdk-$latest_java-jdk"
        # export JAVA_HOME
        export JAVA_HOME=/usr/lib/jvm/java-$latest_java-openjdk-amd64
        # Add JAVA_HOME to .bashrc if not already added
        if ! grep -q "export JAVA_HOME=/usr/lib/jvm/java-$latest_java-openjdk-amd64" $HOME/.bashrc; then
            echo "export JAVA_HOME=/usr/lib/jvm/java-$latest_java-openjdk-amd64" >>$HOME/.bashrc
        fi
        # Add Java to PATH
        export PATH=$PATH:$JAVA_HOME/bin
        # Update PATH if not already updated
        if ! grep -q "$JAVA_HOME/bin" $HOME/.bashrc; then
            # Update .bashrc with Java PATH appended
            sed -i '$ a export PATH=$PATH:$JAVA_HOME/bin' $HOME/.bashrc
        fi
        # Update source
        source $HOME/.bashrc
    else
        echo "Skipping Java installation"
        source $HOME/.bashrc
    fi
fi

# Print Java version
echo "Java version: $(java -version 2>&1 | head -1)"

# Print Java home
echo "Java home: $(echo $JAVA_HOME)"

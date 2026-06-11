#!/bin/bash

# List of packages
packages=("nginx" "curl" "wget")

# Detect package manager
if command -v dpkg >/dev/null 2>&1; then
    PKG_MANAGER="dpkg"
elif command -v rpm >/dev/null 2>&1; then
    PKG_MANAGER="rpm"
else
    echo "Unsupported system: neither dpkg nor rpm found."
    exit 1
fi

# Loop through packages
for pkg in "${packages[@]}"; do
    echo "Checking package: $pkg"

    if [ "$PKG_MANAGER" = "dpkg" ]; then
        if dpkg -s "$pkg" >/dev/null 2>&1; then
            echo "✓ $pkg is already installed. Skipping."
        else
            echo "✗ $pkg is not installed. Installing..."
            sudo apt-get update
            sudo apt-get install -y "$pkg"
        fi
    elif [ "$PKG_MANAGER" = "rpm" ]; then
        if rpm -q "$pkg" >/dev/null 2>&1; then
            echo "✓ $pkg is already installed. Skipping."
        else
            echo "✗ $pkg is not installed. Installing..."
            if command -v dnf >/dev/null 2>&1; then
                sudo dnf install -y "$pkg"
            elif command -v yum >/dev/null 2>&1; then
                sudo yum install -y "$pkg"
            else
                echo "No supported package installer found for RPM-based system."
                exit 1
            fi
        fi
    fi

    echo "----------------------------------------"
done

echo "Package check completed."

#!/bin/bash

set -euo pipefail

echo "Starting strict mode demo..."

# 🔹 1. Undefined variable (set -u)
echo "Trying undefined variable:"
echo "$undefined_var"   # ❌ will cause error

# 🔹 2. Failing command (set -e)
echo "This will not run due to above error"
ls /nonexistent_folder   # ❌ command fails

# 🔹 3. Pipe failure (set -o pipefail)
echo "Testing pipe failure:"
cat missing.txt | grep "hello"   # ❌ pipe fails

echo "Script completed"

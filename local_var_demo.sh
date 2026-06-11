#!/bin/bash

# 🔹 Function using local variable
local_demo() {
    local var="I am local"
    echo "Inside local_demo: $var"
}

# 🔹 Function using global variable
global_demo() {
    var="I am global"
    echo "Inside global_demo: $var"
}

echo "Before function calls:"
echo "var = $var"   # empty

echo "-------------------------"

# Call local function
local_demo
echo "After local_demo:"
echo "var = $var"   # ❌ still empty (not leaked)

echo "-------------------------"

# Call global function
global_demo
echo "After global_demo:"
echo "var = $var"   # ✅ available (leaked globally)

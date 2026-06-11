#!/bin/bash

# Function to check disk usage
check_disk() {
    echo "Disk Usage (/):"
    df -h /
    echo "-----------------------------"
}

# Function to check memory usage
check_memory() {
    echo "Memory Usage:"
    free -h
    echo "-----------------------------"
}

# Main section
echo "System Health Check"
echo "============================="

check_disk
check_memory

echo "Check completed."

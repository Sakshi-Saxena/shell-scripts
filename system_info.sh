#!/bin/bash

set -euo pipefail

# 🔹 Header printer
print_header() {
    echo "========================================"
    echo "$1"
    echo "========================================"
}

# 🔹 Hostname & OS info
system_info() {
    print_header "System Information"
    echo "Hostname: $(hostname)"
    echo "OS: $(uname -o)"
    echo "Kernel: $(uname -r)"
    echo
}

# 🔹 Uptime
uptime_info() {
    print_header "Uptime"
    uptime -p
    echo
}

# 🔹 Disk usage (top 5)
disk_usage() {
    print_header "Top 5 Disk Usage"
    du -h --max-depth=1 / 2>/dev/null | sort -rh | head -n 5 || true
    echo
}

# 🔹 Memory usage
memory_usage() {
    print_header "Memory Usage"
    free -h
    echo
}

# 🔹 Top CPU processes
cpu_usage() {
    print_header "Top 5 CPU Consuming Processes"
    ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6
    echo
}

# 🔹 Main function
main() {
    system_info
    uptime_info
    disk_usage
    memory_usage
    cpu_usage
}

# Execute main
main

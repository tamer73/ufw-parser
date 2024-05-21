#!/bin/bash

# Usage: ./ulog2.sh [min count of matches]

# Default tally is 10, or use the provided command line argument
tally=${1:-10}

# Extract the list of blocked IPs from ufw status
blocked_ips=$(ufw status | awk '/DENY/ {print $3}')

# awk magic
awk -v tally="$tally" -v blocked_ips="$blocked_ips" '
BEGIN {
    # Split the blocked_ips string into an array
    split(blocked_ips, blocked_array)
    for (i in blocked_array) {
        blocked[blocked_array[i]] = 1
    }
    # Print the table header
    printf "%-20s %-10s %-20s %-10s %s\n", "Group", "Count", "Date Time", "Port", "Status"
    printf "%-20s %-10s %-20s %-10s %s\n", "-----", "-----", "---------", "----", "------"
}
$7 ~ /UFW/ && $20 ~ /TCP/ {
    # Extract the IP address from the 12th field (removing SRC= prefix)
    split($12, src, "=")
    ip = src[2]

    # Extract the port number from the 22nd field (removing DPT= prefix)
    split($22, dpt, "=")
    port = dpt[2]

    # Store the first port if not already stored
    if (!data[ip]) {
        data[ip] = port  # Store only the port number
    }
    # Always update $1, $2, and $3 for the last entry (Date and Time)
    last[ip] = $1 " " $2 " " $3
    # Increment count for each group
    count[ip]++
}
END {
    # Transfer counts and data to an array for sorting
    for (key in count) {
        # Combine count as the primary key for sorting with the group key
        sort_arr[sprintf("%09d %s", count[key], key)] = last[key] "\t" data[key]
    }
    # Use numeric sort in descending order by count
    num_keys = asorti(sort_arr, sorted_keys, "@ind_num_desc")
    for (i = 1; i <= num_keys; i++) {
        # Extract count and key from sorted array index
        split(sorted_keys[i], parts, " ")
        count_value = substr(parts[1], 1) + 0
        if (count_value > tally) {
            group_key = substr(sorted_keys[i], 11)
            blocked_label = (blocked[group_key] ? ";34malready blocked\033[0m" : "")
            split(sort_arr[sorted_keys[i]], entry, "\t")
            printf "%-20s \033[1;31m%-10d\033[0m %-20s %-10s %s\n", group_key, count_value, entry[1], entry[2], blocked_label
        }
    }
}' /var/log/ufw.log

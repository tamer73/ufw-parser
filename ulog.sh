#!/usr/bin/sudo bash

# Usage: ./ulogs.sh [tally]

# Default tally is 10, or use the provided command line argument
tally=${1:-10}

# awk magic
awk -v tally="$tally" '
$7 ~ /UFW/ && $20 ~ /TCP/ {
    # Store the first $22 if not already stored
    if (!data[$12]) {
        data[$12] = $22  # Store only $22
    }
    # Always update $1 and $2 for the last entry
    last[$12] = $1 " " $2
    # Increment count for each group
    count[$12]++
}
END {
    # Transfer counts and data to an array for sorting
    for (key in count) {
        # Combine count as the primary key for sorting with the group key
        sort_arr[sprintf("%09d %s", count[key], key)] = last[key] " " data[key]
    }
    # Use numeric sort in descending order by count
    num_keys = asorti(sort_arr, sorted_keys, "@ind_num_desc")
    for (i = 1; i <= num_keys; i++) {
        # Extract count and key from sorted array index
        split(sorted_keys[i], parts, / /, seps)
        if (parts[1] > tally) {
            printf "Group: %s, Count: \033[1;31m%d\033[0m, Entry: %s\n", parts[2], parts[1], sort_arr[sorted_keys[i]]
        }
    }
}' /var/log/ufw.log

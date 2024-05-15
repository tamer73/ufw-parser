#!/bin/bash

# Check if the user has provided a threshold, otherwise set a default
threshold=${1:-1}

# The awk script processing the log with the threshold variable
awk -v threshold="$threshold" '
$7 ~ /UFW/ && $20 ~ /TCP/ {
    # Store the first entry if not already stored, except $1 and $2
    if (!data[$12]) {
        data[$12] = $12 "\t" $22  # Only store $12 and $22 initially
    }
    # Always update $1 and $2 for the last entry
    last[$12] = $1 "\t" $2
    # Increment count for each group
    count[$12]++
}
END {
    # Transfer counts and data to an array for sorting
    for (key in count) {
        sort_arr[count[key], key] = last[key] "\t" data[key]  # Combine last $1, $2 with the first $12, $22
    }
    # Sort by count in descending order using numeric comparison
    num_keys = asorti(sort_arr, sorted_keys, "@ind_num_desc")
    # Print sorted groups with counts greater than the threshold
    for (i = 1; i <= num_keys; i++) {
        split(sorted_keys[i], parts, SUBSEP)  # parts[1] = count, parts[2] = key
        if (parts[1] > threshold) {
            printf "Group: %s, Count: \033[1;31m%d\033[0m, Entry: %s\n", parts[2], parts[1], sort_arr[sorted_keys[i]]
        }
    }
}' /var/log/ufw.log

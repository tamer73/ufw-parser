#!/usr/bin/sudo bash

# This is a shell script named `process_logs.sh`
# Usage: ./process_logs.sh [tally] [sort_by_date]

# Default tally is 1, or use the provided command line argument
tally=${1:-1}
sort_by_date=${2:-0}

# Extract the list of blocked IPs from ufw status
blocked_ips=$(ufw status | awk '/DENY/ {print $3}')

# Properly formatted awk script within a shell script
awk -v tally="$tally" -v blocked_ips="$blocked_ips" -v sort_by_date="$sort_by_date" '
BEGIN {
    # Split the blocked_ips string into an array
    split(blocked_ips, blocked_array)
    for (i in blocked_array) {
        blocked[blocked_array[i]] = 1
    }
    # Print the table header to a temporary file
    printf "%-40s %-3s %-22s %-8s %-13s\n", "Group", "Cnt", "Date_Time", "Port", "Status" > "/tmp/ip_list_unformatted.txt"
    printf "%-40s %-3s %-22s %-8s %-13s\n", "-----", "---", "---------", "----", "------" >> "/tmp/ip_list_unformatted.txt"
}
{
    # Extract the IP address from the SRC= field
    if (match($0, /SRC=([0-9a-fA-F:.]+)/, arr)) {
        ip = arr[1]
    } else {
        next
    }

    # Extract the port number from the DPT= field
    if (match($0, /DPT=([0-9]+)/, arr)) {
        port = arr[1]
    } else {
        port = "-"
    }

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
    new_ips = ""
    # Create a temporary array to hold data for sorting
    for (key in count) {
        if (count[key] > tally) {
            sort_key = (sort_by_date == 1 ? last[key] : sprintf("%09d", count[key]))
            data_array[sort_key, key] = last[key] "\t" data[key] "\t" count[key]
        }
    }
    # Sort the data
    n = asorti(data_array, sorted_data, (sort_by_date == 1 ? "@val_str_desc" : "@ind_num_desc"))
    for (i = 1; i <= n; i++) {
        split(sorted_data[i], arr, SUBSEP)
        key = arr[2]
        value = data_array[sorted_data[i]]
        split(value, entry, "\t")
        blocked_label = (blocked[key] ? "already_blocked" : "not_blocked")
        if (!blocked[key]) {
            new_ips = new_ips key "\n"
        }
        printf "%-40s %03d %-22s %-8s %-13s\n", key, entry[3], entry[1], entry[2], blocked_label >> "/tmp/ip_list_unformatted.txt"
    }
    # Write new IPs to the temporary file without printing them
    if (new_ips) {
        print new_ips > "/tmp/new_ips.txt"
    }
}' /var/log/ufw.log

# Format the output file with column -t
column -t /tmp/ip_list_unformatted.txt > /tmp/ip_list.txt

# Prepare dialog options
dialog_options=()
dialog_options+=("ALL" "Select all IP groups" "off")
dialog_options+=("Group" "Cnt  Date_Time            Port    Status" "off")
dialog_options+=("-----" "---  ---------            ----    ------" "off")
while IFS= read -r line; do
    if [[ $line == "Group"* || $line == "-----"* ]]; then
        continue
    else
        ip=$(echo $line | awk '{print $1}')
        details=$(echo $line | awk '{$1=""; print $0}')
        dialog_options+=("$ip" "$details" "off")
    fi
done < /tmp/ip_list.txt

# Use dialog to present the options with reduced width
dialog --title "Select IPs to Block" \
       --checklist "Select the IPs you want to block:\n\n" 20 100 15 \
       "${dialog_options[@]}" 2> /tmp/selected_ips.txt

response=$?
if [ $response -eq 0 ]; then
    selected_ips=$(cat /tmp/selected_ips.txt)
    rm /tmp/selected_ips.txt
    if [[ "$selected_ips" == *ALL* ]]; then
        selected_ips=$(awk 'NR>3 {print $1}' /tmp/ip_list.txt)
    fi
    if [ -n "$selected_ips" ]; then
        echo "$selected_ips" | tr -d '"' | while read -r ip; do
            if [ -n "$ip" ]; then
                sudo ufw deny from "$ip"
            fi
        done
        sudo ufw reload
        dialog --title "Success" --msgbox "Selected IPs have been blocked." 7 60
    else
        dialog --title "No Action" --msgbox "No IPs were selected to block." 7 60
    fi
else
    dialog --title "No Action" --msgbox "No IPs were blocked." 7 60
fi

# Clear the screen to reset the console
clear

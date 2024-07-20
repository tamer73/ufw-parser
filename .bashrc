# this is a funktion to get some infos of an ip address - getting the counts, port and time range of ip port blocks from ufw.log
cip() {
    if [ -z "$1" ]; then
        echo "Usage: check_ip_details <IP_ADDRESS>"
        return 1
    fi

    IP="$1"
    BLUE=$(tput setaf 4)
    RED=$(tput setaf 1)
    NC=$(tput sgr0) # No Color

    echo ""    
    echo -e "${BLUE}UFW Log Details for IP: $IP${NC}"
    cat /var/log/ufw.log | grep "$IP" | awk '/DPT/ {for(i=1;i<=NF;i++) if($i ~ /DPT=/) port=$i} {print $1, $2, $3, port}' | sed 's/DPT=//' | sort -k4,4n | awk -v red="$RED" -v nc="$NC" 'NR==1{first_access=$1 " " $2 " " $3; lowest_port=$4} {count++} END{printf " %-20s %s\n", " Total Entries:", red count nc; printf " %-20s %-20s\n", " First Access:", first_access; printf " %-20s %-20s\n", " Last Access:", $1 " " $2 " " $3; printf " %-20s %-20s\n", " Lowest Port:", lowest_port; printf " %-20s %-20s\n", " Highest Port:", $4}'

    echo ""
    echo -e "${BLUE}WHOIS Information for IP: $IP${NC}"
    whois "$IP" | grep -E 'OrgName|OrgId|Address|City|StateProv|PostalCode|Country|RegDate|Updated|inetnum|netname|descr|admin-c|tech-c' | awk -v red="$RED" -v nc="$NC" -F: '{gsub(/^[ \t]+|[ \t]+$/, "", $1); gsub(/^[ \t]+|[ \t]+$/, "", $2); if ($1 == "descr") {printf "  %-20s %s\n", $1, red $2 nc} else {printf "  %-20s %s\n", $1, $2}}'
    echo ""
}

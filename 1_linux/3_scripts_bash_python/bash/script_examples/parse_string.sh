# Parse comma-separated data into one value per line.

STR="server1, server2, server3"

IFS=', ' read -ra NAMES <<< "$STR"

for name in "${NAMES[@]}"; do
    printf '%s\n' "$name"
done

#!/bin/bash

#######
# To connect to remote machines by SSH password based authentication and perform desired configurations on them.  
########
# Check if the necessary argument is provided
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <subnet> <username> <password>"
    exit 1
fi

SUBNET=$1       # The subnet (e.g., 192.168.1)
USER=$2         # The SSH username
PASS=$3         # The SSH password

# Function to attempt SSH connection
attempt_ssh() {
    IP=$1
    echo "Attempting to connect to $IP..."
    sshpass -p "$PASS" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 "$USER"@"$IP" exit 2>/dev/null
    if [ $? -eq 0 ]; then
        echo "Successfully connected to $IP"
    else
        echo "Failed to connect to $IP"
    fi
}

# Loop through IP addresses in the given subnet (e.g., 192.168.1.1 to 192.168.1.254)
for i in {1..254}; do
    IP="$SUBNET.$i"
    attempt_ssh $IP &
done

# Wait for all background processes to finish
wait
echo "SSH attempts complete."


#!/bin/bash

DOMAIN_NAME="$1"

# Check if a domain name was provided
if [ -z "$DOMAIN_NAME" ]; then
  echo "Usage: $0 (domain_name/ID)"
  exit 1
fi

read -p "Are you sure? (y/n): " answer

# Check the user's input
if [[ "$answer" =~ ^[Yy]$ ]]; then
    echo "Proceeding..."
else
    echo "Aborting..."
    exit
fi


### IMPORT VARS ###

import_auth_vars() {
  # Check if auth.txt or auth.bin exists
  if [[ ! -f "auth.txt" && ! -f "auth.bin" ]]; then
    echo "No auth file found!"
    return 1
  fi

  # Detect whether the file is encrypted (auth.bin) or plaintext (auth.txt)
  if [[ -f "auth.bin" ]]; then
    # File is encrypted, prompt for password
    echo "The file appears to be encrypted."
    read -s -p "Enter password to decrypt: " PASSWORD
    echo

    # Attempt to decrypt and source variables
    decrypted_data=$(openssl enc -aes-256-cbc -d -pbkdf2 -in auth.bin -k "$PASSWORD" 2>/dev/null)

    if [[ $? -ne 0 ]]; then
      echo "Failed to decrypt the file. Incorrect password or file corrupted."
      return 1
    fi

    # Read the decrypted data into the current environment
    eval "$decrypted_data"
  elif [[ -f "auth.txt" ]]; then
    # File is in plaintext, source it directly
    source auth.txt
  fi

  # Verify the variables have been imported
  if [[ -z "$APIKEY" || -z "$EMAIL" || -z "$ZONE_ID" ]]; then
    echo "Failed to import variables from the auth file"
    return 1
  fi
}

# Import auth file
import_auth_vars

### END IMPORT VARS ###

# Function to check if input is a valid ID (32-character hex string)
is_id() {
    [[ $1 =~ ^[0-9a-fA-F]{32}$ ]]
}

if is_id "$1"; then
        END=$(curl -s --request DELETE "https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/dns_records/$1" \
         -H "X-Auth-Email: ${EMAIL}" \
         -H "X-Auth-Key: ${APIKEY}" \
         -H "Content-Type: application/json")
    echo "Success:"
    echo "$END" | jq '.success'
    exit
else
    # Make the API request to retrieve DNS records for the specified domain
    RESPONSE=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/dns_records?name=${DOMAIN_NAME}" \
          -H "X-Auth-Email: ${EMAIL}" \
          -H "X-Auth-Key: ${APIKEY}" \
          -H "Content-Type: application/json")

    # Check if the API call was successful
    if echo "$RESPONSE" | grep -q '"success":false'; then
       echo "Error retrieving DNS records:"
       echo "$RESPONSE" | jq '.errors[] | {code, message}'
    fi
fi

# Extract and display the DNS record IDs
       echo "DNS Record IDs for ${DOMAIN_NAME}:"
       ID=$(echo "$RESPONSE" | jq -r '.result[] | "\(.id)"')
       echo $ID

END=$(curl -s --request DELETE "https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/dns_records/$ID" \
     -H "X-Auth-Email: ${EMAIL}" \
     -H "X-Auth-Key: ${APIKEY}" \
     -H "Content-Type: application/json")
echo "Success:"
echo "$END" | jq '.success'


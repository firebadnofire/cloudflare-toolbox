#!/bin/bash

#!/bin/bash
### IMPORT VARS ###

# Function to import variables from auth.txt (encrypted or plaintext)
import_auth_vars() {
  # Check if auth.txt exists
  if [[ ! -f "auth.txt" ]]; then
    echo "auth.txt not found!"
    return 1
  fi

  # Try to detect if the file is encrypted
  file_type=$(file --mime auth.txt)

  if [[ $file_type == *"application/octet-stream"* ]]; then
    # File is likely encrypted, prompt for password
    echo "The file appears to be encrypted."
    read -s -p "Enter password to decrypt: " PASSWORD
    echo

    # Attempt to decrypt and source variables
    decrypted_data=$(openssl enc -aes-256-cbc -d -pbkdf2 -in auth.txt -k "$PASSWORD" 2>/dev/null)

    if [[ $? -ne 0 ]]; then
      echo "Failed to decrypt the file. Incorrect password or file corrupted."
      return 1
    fi

    # Read the decrypted data into the current environment
    eval "$decrypted_data"

  else
    # File is in plaintext, source it directly
    source auth.txt
  fi

  # Verify the variables have been imported
  if [[ -z "$APIKEY" || -z "$EMAIL" || -z "$ZONE_ID" ]]; then
    echo "Failed to import variables from auth.txt"
    return 1
  fi
}

# Import auth.txt
import_auth_vars

### END IMPORT VARS ###


# Check if a domain name was provided
if [ -z "$1" ]; then
  echo "Usage: $0 domain_name IP"
  exit 1
fi

# Check if an IP was provided
if [ -z "$2" ]; then
  echo "Usage: $0 domain_name IP"
  exit 1
fi

# DNS record details
RECORD_TYPE="A"
RECORD_NAME=$1
RECORD_CONTENT=$2
RECORD_TTL=1       # Auto TTL
PROXIED=false      # Whether the record is proxied through Cloudflare

# API endpoint
API_ENDPOINT="https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records"

# Prepare JSON data
read -r -d '' JSON_DATA << EOF
{
  "type": "$RECORD_TYPE",
  "name": "$RECORD_NAME",
  "content": "$RECORD_CONTENT",
  "ttl": $RECORD_TTL,
  "proxied": $PROXIED
}
EOF

# Make the API request
END=$(curl -X POST "$API_ENDPOINT" \
     -H "X-Auth-Email: $EMAIL" \
     -H "X-Auth-Key: $APIKEY" \
     -H "Content-Type: application/json" \
     --data "$JSON_DATA")
echo "Success:"
echo "$END" | jq '.success'


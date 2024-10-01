#!/bin/bash
usage() {
  echo "Usage: $0 sub.your.domain contents record_type [true/false]"
  echo
  echo "  sub.your.domain		domain of the record"
  echo "  contents			contents of the record"
  echo "  record_type			record type (A, AAAA, CNAME, etc.)"
  echo "  [true/false]			true = proxied by Cloudflare (optional, defaults to false)"
  echo
  echo "Options:"
  echo "  -h, --help  Show this help message and exit"
}

if [ $# -lt 3 ]; then
  usage
  exit 1
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

# DNS record details
RECORD_TYPE=$3
RECORD_NAME=$1
RECORD_CONTENT=$2
RECORD_TTL=1       # Auto TTL
PROXIED=${4:-"false"}      # Whether the record is proxied through Cloudflare

if [ "$PROXIED" = "true" ]; then
  PROXIED=true
elif [ "$PROXIED" = "false" ]; then
  PROXIED=false
else
  echo "Invalid value for proxy status. Please use true or false."
  exit 1
fi

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


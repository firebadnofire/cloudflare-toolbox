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

# The domain name to query (passed as the first argument to the script)
DOMAIN_NAME="$1"

# Check if a domain name was provided
if [ -z "$DOMAIN_NAME" ]; then
  echo "Usage: $0 domain_name"
  exit 1
fi

# Make the API request to retrieve DNS records for the specified domain
RESPONSE=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/dns_records?name=${DOMAIN_NAME}" \
     -H "X-Auth-Email: ${EMAIL}" \
     -H "X-Auth-Key: ${APIKEY}" \
     -H "Content-Type: application/json")

# Check if the API call was successful
if echo "$RESPONSE" | grep -q '"success":false'; then
  echo "Error retrieving DNS records:"
  echo "$RESPONSE" | jq '.errors[] | {code, message}'
  exit 1
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


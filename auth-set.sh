#!/bin/bash

# Function to securely store data with encryption
store_secure_data() {
  local APIKEY="$1"
  local EMAIL="$2"
  local ZONE_ID="$3"
  local PASSWORD="$4"

  # Encrypt data with PBKDF2 and save as auth.bin
  echo -e "APIKEY=$APIKEY\nEMAIL=$EMAIL\nZONE_ID=$ZONE_ID" | openssl enc -aes-256-cbc -salt -pbkdf2 -k "$PASSWORD" -out auth.bin

  # Set restrictive permissions
  chmod 600 auth.bin

  # Delete auth.txt if it exists
  [ -f auth.txt ] && rm -f auth.txt

  echo "Data has been encrypted and stored securely in auth.bin"
}

# Function to securely store plaintext data
store_plaintext_data() {
  local APIKEY="$1"
  local EMAIL="$2"
  local ZONE_ID="$3"

  # Store data in plaintext and save as auth.txt
  echo -e "APIKEY=$APIKEY\nEMAIL=$EMAIL\nZONE_ID=$ZONE_ID" > auth.txt

  # Set restrictive permissions
  chmod 600 auth.txt

  # Delete auth.bin if it exists
  [ -f auth.bin ] && rm -f auth.bin

  echo "Data has been stored in plaintext in auth.txt"
}

# Prompt for user input
read -p "Enter your Cloudflare API Global Key: " APIKEY
read -p "Enter your Cloudflare email: " EMAIL
read -p "Enter your Cloudflare Zone ID: " ZONE_ID

# Prompt for password (optional)
echo "You may enter a password to encrypt the data (leave blank for plaintext):"
read -s PASSWORD1

if [[ -n "$PASSWORD1" ]]; then
  echo "Re-enter password to confirm:"
  read -s PASSWORD2

  if [[ "$PASSWORD1" != "$PASSWORD2" ]]; then
    echo "Passwords do not match. Exiting for security reasons."
    exit 1
  fi

  # Check for minimum password length
  if [[ ${#PASSWORD1} -lt 8 ]]; then
    echo "Password is too short (minimum 8 characters). Exiting."
    exit 1
  fi

  # Securely store encrypted data
  store_secure_data "$APIKEY" "$EMAIL" "$ZONE_ID" "$PASSWORD1"
else
  # Store data in plaintext
  store_plaintext_data "$APIKEY" "$EMAIL" "$ZONE_ID"
fi

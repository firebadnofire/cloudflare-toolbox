#!/bin/bash

# Function to decrypt the data securely
decrypt_secure_data() {
  local PASSWORD="$1"

  # Attempt decryption with PBKDF2
  decrypted_data=$(openssl enc -aes-256-cbc -d -pbkdf2 -in auth.bin -k "$PASSWORD" 2>/dev/null)

  if [[ $? -ne 0 ]]; then
    echo "Failed to decrypt the file. Incorrect password or file corrupted."
    exit 1
  fi

  echo "$decrypted_data"
}

# Check if the auth file exists
if [[ -f "auth.txt" ]]; then
  # File is plaintext, print contents securely
  echo "The file is in plaintext. Contents:"
  cat auth.txt
elif [[ -f "auth.bin" ]]; then
  # File is encrypted, prompt for password
  echo "The file appears to be encrypted."
  read -s -p "Enter password to decrypt: " PASSWORD
  echo

  # Decrypt the data
  decrypt_secure_data "$PASSWORD"
else
  echo "No auth file found!"
  exit 1
fi

# Set restrictive permissions
chmod 600 auth.txt 2>/dev/null
chmod 600 auth.bin 2>/dev/null

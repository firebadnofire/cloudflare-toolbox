#!/bin/bash

# Function to decrypt the data securely
decrypt_secure_data() {
  local PASSWORD="$1"

  # Attempt decryption with PBKDF2
  decrypted_data=$(openssl enc -aes-256-cbc -d -pbkdf2 -in auth.txt -k "$PASSWORD" 2>/dev/null)

  if [[ $? -ne 0 ]]; then
    echo "Failed to decrypt the file. Incorrect password or file corrupted."
    exit 1
  fi

#  echo "Decrypted variables:"
  echo "$decrypted_data"
}

# Check if auth.txt exists
if [[ ! -f "auth.txt" ]]; then
  echo "auth.txt not found!"
  exit 1
fi

# Set restrictive permissions
chmod 600 auth.txt

# Try to detect if the file is encrypted
file_type=$(file --mime auth.txt)

if [[ $file_type == *"application/octet-stream"* ]]; then
  # File is likely encrypted, prompt for password
  echo "The file appears to be encrypted."
  read -s -p "Enter password to decrypt: " PASSWORD
  echo

  # Decrypt the data
  decrypt_secure_data "$PASSWORD"
else
  # File is in plaintext, print contents securely
  echo "The file is in plaintext. Contents:"
  cat auth.txt
fi

# Cloudflare Toolbox

Cloudflare Toolbox is a collection of bash scripts for basic domain management with Cloudflare over the CLI using [cURL](https://curl.se/) to access the Cloudflare API

```
cfplace - place a record with a target domain
Usage: cfplace sub.your.domain contents record_type [true/false]

cflocate - locate the DNS record ID of a domain
Usage: cflocate sub.your.domain

cflocate - remove a DNS record
Usage: cflocate (sub.your.domain/ID)

cfsetauth - set authorization credentials (and optionally encrypt them with a password)
Usage: cfsetauth 
(interactive)

cfgetauth - (decrypt and) print the authorization info
Usage: cfgetauth 
(interactive)
```

When running `cfsetauth` the system will create `auth.txt` and prompt you for the below items. These are stored in auth.txt and/or auth.bin (and can be encrypted at store time by the script using a password, which you SHOULD do.) and loaded by the scripts (will be prompted at runtime for decryption password if needed). As zone IDs are used to make requests, you can only use the scripts on one domain at a time. To switch operating domains, switch the zone ID to the desired domain's zone ID.

```
Your Cloudflare *Global API* key
Your Cloudflare email
Your Cloudflare zone ID (used to identify the domain)
```

This information is stored in ~/.config/cloudflare-toolbox/ with 600 (-rw-------) permissions on the dir. You may encrypt the `auth.txt` file with a password or SSH key, where it becomes `auth.bin`.

If you decide you do not need or want to encrypt the auth.txt file, you may. This is strongly discouraged, as if your concern is having to continuously type passwords you can generate a SSH key with no password. While less secure than an SSH key with a password, it's still better than no password at all.

# Dependencies

`bash curl openssl jq`

# Installation of Cloudflare Toolbox on various systems:

## Debian:

```
sudo apt install -y bash curl openssl jq
git clone https://codeberg.org/firebadnofire/cloudflare-toolbox
```

## Fedora/RHEL:

```
sudo dnf install -y bash curl openssl jq
git clone https://codeberg.org/firebadnofire/cloudflare-toolbox
```
## Arch:

```
sudo pacman --needed -S bash curl openssl jq
git clone https://codeberg.org/firebadnofire/cloudflare-toolbox
```
## FreeBSD:

```
pkg bash curl openssl jq
git clone https://codeberg.org/firebadnofire/cloudflare-toolbox
```

# Why SSH keys and not PGP keys?

Simply put, PGP is old, clunky, and complex. SSH keys are simpler and nearly server owner (and developer since Git uses them) has one already. [This aricle](https://www.agwa.name/blog/post/ssh_signatures) helps summarize some issues.

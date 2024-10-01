# Cloudflare Toolbox

Cloudflare Toolbox is a collection of bash scripts for basic domain management with Cloudflare over the CLI using [cURL](https://curl.se/) to access the Cloudflare API

```
place-A.sh - place an A record with an IPv4
Usage: ./place-A.sh sub.your.domain 1.2.3.4

place-AAAA.sh - place an AAAA record with an IPv6
Usage: ./place-AAAA.sh sub.your.domain ::1

place-CNAME.sh - place a CNAME record with a target domain
Usage: ./place-CNAME.sh sub1.your.domain sub2.your.domain

locate.sh - locate the DNS record ID of a domain
Usage: ./locate.sh sub.your.domain

remove.sh - remove a DNS record
Usage: ./remove.sh sub.your.domain 

auth-set.sh - set authorization credentials (and optionally encrypt them with a password)
Usage: ./auth-set.sh 
(interactive)

auth-get.sh - (decrypt and) print the authorization into
Usage: ./auth-get.sh 
(interactive)
```

```
Your Cloudflare *Global API* key
Your Cloudflare email
Your Cloudflare zone ID (used to identify the domain)
```

When running `./auth-set.sh` the system will create auth.txt and prompt you for the above items. These are stored in auth.txt (and can be encrypted at store time by the script using a password, which you **SHOULD** do.) and loaded by the scripts (will be prompted at runtime for decryption password if needed). As zone IDs are used to make requests, you can only use the scripts on one domain at a time. To switch operating domains, switch the zone ID to the desired domain's zone ID.

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

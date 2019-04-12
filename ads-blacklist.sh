#!/bin/sh

## Clean up any stale tempfile
echo "Removing old files..."
[ -f /tmp/hosts.working ] && rm -f /tmp/hosts.working

## Awk regex to be inverse-matched as whitelist
# - Project Wonderful does unobtrusive ads on a lot of webcomics
# - SolveMedia is needed for captchas on some websites
whitelist='/(api.solvemedia.com)/'
blacklist='http://winhelp2002.mvps.org/hosts.txt https://adaway.org/hosts.txt http://sysctl.org/cameleon/hosts 
https://hosts-file.net/ad_servers.txt https://hosts-file.net/grm.txt https://hosts-file.net/hfs.txt https://hosts-file.net/mmt.txt 
https://hosts-file.net/emd.txt https://hosts-file.net/fsa.txt https://hosts-file.net/exp.txt https://hosts-file.net/hjk.txt 
https://hosts-file.net/psh.txt https://hosts-file.net/pha.txt 
http://pgl.yoyo.org/as/serverlist.php?hostformat=hosts&showintro=0&mimetype=plaintext https://someonewhocares.org/hosts/zero 
https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn/hosts'


## Fetch all Blacklist Files
echo "Fetching Blacklists..."
for url in $blacklist; do
    curl --silent $url >> "/tmp/hosts.working"
done

## Process Blacklist, Eliminiating Duplicates, Integrating Whitelist, and Converting to unbound format
echo "Processing Blacklist..."
awk -v whitelist="$whitelist" '$1 ~ /^127\.|^0\./ && $2 !~ whitelist {gsub("\r",""); print tolower($2)}' /tmp/hosts.working | sort | 
uniq | \
awk '{printf "local-data: \"%s A 0.0.0.0\"\n", $1}' > /var/unbound/ads-blacklist.conf

# Clean up tempfile
echo "Cleaning Up..."
rm -f '/tmp/hosts.working'
echo "Done. Please Verify the DNS Resolver service from the WebUI."

# Make unbound reload config to activate the new blacklist
echo "Restarting unbound..."
exec pluginctl dns


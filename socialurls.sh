#!/bin/sh

###############################################################################
# Copyright 2018-2019 Amri Mohamed                                            #
#                                                                             #
#    Licensed under the GNU GPLv3 (the "License"); you may                    #
#    not use this file except in compliance with the License. You may obtain  #
#    a copy of the License at                                                 #
#                                                                             #
#         https://www.gnu.org/licenses/gpl.html                               #
#                                                                             #
# file name: socialurls.sh                                                    #
# this script will perform a download and formatting of a hosts file          #
# containing a list of social networks URLs                                   #
# To use as an OPNsense proxy ACL or as firewall alias of type URL Table (IPs)#
###############################################################################

## Clean up any stale tempfile
echo "Removing old files..."
[ -f /tmp/hosts.working ] && rm -f /tmp/hosts.working

whitelist='127.0.0.1'
blacklist='http://winhelp2002.mvps.org/hosts.txt https://adaway.org/hosts.txt http://sysctl.org/cameleon/hosts https://hosts-file.net/ad_servers.txt https://hosts-file.net/grm.txt https://hosts-file.net/hfs.txt https://hosts-file.net/mmt.txt https://hosts-file.net/emd.txt https://hosts-file.net/fsa.txt https://hosts-file.net/exp.txt https://hosts-file.net/hjk.txt https://hosts-file.net/psh.txt https://hosts-file.net/pha.txt http://pgl.yoyo.org/as/serverlist.php?hostformat=hosts&showintro=0&mimetype=plaintext'

## Fetch all Blacklist Files
echo "Fetching Blacklists..."
for url in $blacklist; do
    curl --silent $url >> "/tmp/hosts.working"
done

## Make dir if not exists
mkdir -p /usr/local/www/myblacklists

## Process Blacklist, Eliminiating Duplicates, Integrating Whitelist, and 
## Converting to URL Table format
awk -v whitelist="$whitelist" '$1 ~ /^127\.|^0\./ && $2 !~ whitelist {gsub("\r",""); \
print tolower($2)}' /tmp/hosts.working | sort | uniq | \
awk '{printf $1; printf "\n"}' > /usr/local/www/myblacklists/socialurls


echo "Cleaning Up..."
rm -f '/tmp/hosts.working'
echo "Done."

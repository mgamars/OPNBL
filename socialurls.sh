#!/bin/sh


###############################################################################
# The MIT License (MIT)                                                       #
#                                                                             #
# Copyright (c) 2016 Sinfonietta                                              #
#                                                                             #
# Copyright 2018-2019 amtn                                                    #
# file name: socialurls.sh                                                    #
# this script will perform a download and formatting of a hosts file          #
# containing a list of social networks URLs                                   #
# To use as an OPNsense proxy ACL or as firewall alias of type URL Table (IPs)#
###############################################################################

## Clean up any stale tempfile
echo "Removing old files..."
[ -f /tmp/hosts.working ] && rm -f /tmp/hosts.working

whitelist='127.0.0.1'
blacklist='https://raw.githubusercontent.com/Sinfonietta/hostfiles/master/social-hosts'

## Fetch all Blacklist Files
echo "Fetching Blacklists..."
for url in $blacklist; do
    curl --silent $url >> "/tmp/hosts.working"
done

## Make dir if not exists
#mkdir -p /usr/local/www/myblacklists

## Process Blacklist, Eliminiating Duplicates, Integrating Whitelist, and 
## Converting to URL Table format
awk -v whitelist="$whitelist" '$1 ~ /^127\.|^0\./ && $2 !~ whitelist {gsub("\r",""); \
print tolower($2)}' /tmp/hosts.working | sort | uniq | \
awk '{printf $1; printf "\n"}' > ./socialurls
##awk '{printf $1; printf "\n"}' > /usr/local/www/myblacklists/socialurls


echo "Cleaning Up..."
rm -f '/tmp/hosts.working'
echo "Done."

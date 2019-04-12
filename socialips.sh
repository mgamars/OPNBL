#!/bin/sh

###############################################################################
# Copyright 2018-2019 amtn                                           #
#                                                                             #
#    Licensed under the GNU GPLv3 (the "License"); you may                    #
#    not use this file except in compliance with the License. You may obtain  #
#    a copy of the License at                                                 #
#                                                                             #
#         https://www.gnu.org/licenses/gpl.html                               #
#                                                                             #
# file name: socialips.sh                                                     #
# this script will fetch and format a list of facebook and twitter IPs        #
# To use as an OPNsense proxy ACL or as firewall alias of type URL Table (IPs)#
###############################################################################

# Make dir if not exists
mkdir -p /usr/local/www/myblacklists

`whois -h whois.radb.net -- '-i origin AS32934' | grep ^route | \
grep -v route6 | cut -d " " -f7 > /usr/local/www/myblacklists/socialips`
`whois -h whois.radb.net -- '-i origin AS13414' | grep ^route | \
grep -v route6 | cut -d " " -f7 >> /usr/local/www/myblacklists/socialips`

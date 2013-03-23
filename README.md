AlwaysAppendSearchDomains
=========================

This script is intended to fix a bug in MacOSX when accessing resources (web sites, servers)
with a name of the form aaa.bbb where the true hostname is in fact aaa.bbb.search.domain.

For details please see: 
* http://apple.stackexchange.com/questions/50457/nslookup-works-ping-and-ssh-dont-os-x-lion-10-7-3
* http://www.eigenspace.org/2011/07/fixing-osx-lion-dns-search-domains/
* http://www.makingitscale.com/2011/broken-search-domain-resolution-in-osx-lion.html

To apply the changes:

1. Open Terminal.app
2.  `cd <directory holding the scripts>`
3.  `./AlwaysAppendSearchDomains.sh`

To remove the changes and restore the default configuration:

1. Open Terminal.app
2. `cd <directory holding the scripts>`
3. `./uninstall.sh`

This script may ask for your administrator password (if you have not recently authenticated),
and will update a single file  (/System/Library/LaunchDaemons/com.apple.mDNSResponder.plist)
before restarting the name resolution system on your machine.

Originally written by Mike Thomson (mike@m-thomson.net)

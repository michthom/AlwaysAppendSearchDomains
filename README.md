AlwaysAppendSearchDomains
=========================

2016-10-18 
With thanks to Pieter Lange, there's a new and better way to do this, please ignore the scripts if you're on a modern version of MacOS.

The intention is to fix a behaviour in MacOSX when accessing resources (web sites, servers)
with a name of the form aaa.bbb where the true hostname is in fact aaa.bbb.search.domain.

This bug means for example you can use `nslookup` to resolve a hostname but when you try to
`ping` the same hostname the Mac complains it can't resolve the addres. Very peculiar.

For details please see: 
* http://apple.stackexchange.com/questions/50457/nslookup-works-ping-and-ssh-dont-os-x-lion-10-7-3
* http://www.eigenspace.org/2011/07/fixing-osx-lion-dns-search-domains/
* http://www.makingitscale.com/2011/broken-search-domain-resolution-in-osx-lion.html

The 'new way' in macOS Sierra (and El Capitan?) to do this is to run (in Terminal):

    sudo launchctl unload /System/Library/LaunchDaemons/com.apple.mDNSResponder.plist
    sudo defaults write /Library/Preferences/com.apple.mDNSResponder.plist AlwaysAppendSearchDomains -bool YES
    sudo launchctl load /System/Library/LaunchDaemons/com.apple.mDNSResponder.plist

And to revert to the default behaviour:

    sudo launchctl unload /System/Library/LaunchDaemons/com.apple.mDNSResponder.plist
    sudo defaults write /Library/Preferences/com.apple.mDNSResponder.plist AlwaysAppendSearchDomains -bool NO
    sudo launchctl load /System/Library/LaunchDaemons/com.apple.mDNSResponder.plist

For anyone remaining on an older version of MacOS X, the scripts described below have been moved to the "older" folder.

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

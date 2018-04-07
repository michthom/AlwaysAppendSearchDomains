AlwaysAppendSearchDomains
=========================

2017-08-08
With thanks to Randy Fay.
Sierra and above complains when you try to unload the mDNSResponder because of System Integrity Protection (SIP):

<code>/System/Library/LaunchDaemons/com.apple.mDNSResponder.plist: Operation not permitted while System Integrity Protection is engaged</code>

If you choose to disable SIP to complete the steps in Pieter's updated fix, you need to follow Apple's instructions (from https://developer.apple.com/library/content/documentation/Security/Conceptual/System_Integrity_Protection_Guide/ConfiguringSystemIntegrityProtection/ConfiguringSystemIntegrityProtection.html):
1. Shut down fully
2. Start up while holding down Command-R
3. Choose Utilities > Terminal from the menu bar
4. Type the commands:
   *    csrutil disable
   *    reboot

Then follow Pieter's steps below, and then re-enable SIP afterwards by repeating the above using "csrutil enable" instead. 

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

The 'new way' in macOS Sierra (and tested also in El Capitan) to do this is to run (in Terminal):

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

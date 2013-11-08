#!/bin/bash

cat <<!EOD

This script is intended to fix a bug in MacOSX when accessing resources (web sites, servers)
with a name of the form aaa.bbb where the true hostname is in fact aaa.bbb.search.domain.

For details please see: 
  http://apple.stackexchange.com/questions/50457/nslookup-works-ping-and-ssh-dont-os-x-lion-10-7-3
  http://www.eigenspace.org/2011/07/fixing-osx-lion-dns-search-domains/
  http://www.makingitscale.com/2011/broken-search-domain-resolution-in-osx-lion.html

This script may ask for your administrator password (if you have not recently authenticated),
and will update a single file  (/System/Library/LaunchDaemons/com.apple.mDNSResponder.plist)
before restarting the name resolution system on this machine.

Originally written by Mike Thomson (mike@m-thomson.net)

!EOD

LIBFILE="/System/Library/LaunchDaemons/com.apple.mDNSResponder.plist"
LOCALCOPY="./com.apple.mDNSResponder.plist.original"
LOCALEDIT="./com.apple.mDNSResponder.plist.new"

sudo cp -a ${LIBFILE} ${LOCALCOPY}

cp ${LOCALCOPY} ${LOCALEDIT}

patch --forward --unified -p0 ${LOCALEDIT} <<-!EOD
--- com.apple.mDNSResponder.plist.original  2013-03-23 20:50:33.000000000 +0000
+++ com.apple.mDNSResponder.plist.new	2013-03-23 20:51:18.000000000 +0000
@@ -16,2 +16,3 @@
 	<array>
 		<string>/usr/sbin/mDNSResponder</string>
+		<string>-AlwaysAppendSearchDomains</string>
!EOD

if [ $? -ne 0 ]; then 
{
  echo "File patching failed. Aborting"
  exit 255
}
fi

# Copy original ownership and permissions
     chmod `stat -f %p ${LOCALCOPY}` ${LOCALEDIT}
sudo chown `stat -f %u ${LOCALCOPY}` ${LOCALEDIT}
sudo chgrp `stat -f %g ${LOCALCOPY}` ${LOCALEDIT}

# Put it back in place
sudo cp -a ${LOCALEDIT} ${LIBFILE}

if [ $? -ne 0 ]; then 
{
  echo "File writeback failed. Aborting"
  exit 255
}
fi

{
  echo "Restarting mDNSResponder"
  sudo launchctl unload -w ${LIBFILE}
  if [ $? -ne 0 ]; then 
  {
    echo "launchctl unload failed. Aborting"
    exit 255
  }
  fi

  sudo launchctl load -w ${LIBFILE}
  if [ $? -ne 0 ]; then 
  {
    echo "launchctl load failed. Aborting"
    exit 255
  }
  fi
}

echo "Completed successfully."
ls -l ${LOCALCOPY}
ls -l ${LOCALEDIT}
ls -l ${LIBFILE}

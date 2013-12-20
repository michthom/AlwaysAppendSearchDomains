#!/bin/bash

cat <<!EOD

This script is intended to fix a bug in MacOSX when accessing resources (web sites, servers)
with a name of the form aaa.bbb where the true hostname is in fact aaa.bbb.search.domain.

An example are the Sharepoint sites in Orange hosted under http://share.intranet/teams/...

For details please see: 
  http://apple.stackexchange.com/questions/50457/nslookup-works-ping-and-ssh-dont-os-x-lion-10-7-3
  http://www.eigenspace.org/2011/07/fixing-osx-lion-dns-search-domains/
  http://www.makingitscale.com/2011/broken-search-domain-resolution-in-osx-lion.html

This script may ask for your administrator password (if you have not recently authenticated),
and will update a single file  (/System/Library/LaunchDaemons/com.apple.mDNSResponder.plist)
before restarting the name resolution system on this machine.

If it aborts, please contact the Brilliant Desk or Equanet (0845 37 01 889) for further support.
Originally written by Mike Thomson (michael.thomson@ee.co.uk, 07977 415 639)

!EOD

LIBFILE="/System/Library/LaunchDaemons/com.apple.mDNSResponder.plist"
LOCALCOPY="./com.apple.mDNSResponder.plist.original"
LOCALEDIT="./com.apple.mDNSResponder.plist.new"

cp ${LIBFILE} ${LOCALCOPY}
cp ${LOCALCOPY} ${LOCALEDIT}

patched_before=`fgrep AlwaysAppendSearchDomains ${LOCALCOPY}`

if [ ! -z "${patched_before}" ]; then
{
  echo "File has already been patched! Aborting."
  exit 255
}
fi

sed -E '/<string>\/usr\/sbin\/mDNSResponder<\/string>/ a\
\		<string>-AlwaysAppendSearchDomains</string>
' ${LOCALCOPY} > ${LOCALEDIT}

# Put it back in place
sudo cp -a ${LOCALEDIT} ${LIBFILE}

if [ $? -ne 0 ]; then 
{
  echo "File writeback failed. Aborting"
  exit 255
}
fi

# Copy original ownership and permissions
sudo chmod 0644  ${LIBFILE}
sudo chown root  ${LIBFILE}
sudo chgrp wheel ${LIBFILE}

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

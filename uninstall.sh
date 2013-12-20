#!/bin/bash

cat <<!EOD

This script removes the changes applied to fix a bug in MacOSX when accessing resources
(web sites, servers) with a name of the form aaa.bbb where the true hostname is in fact
aaa.bbb.search.domain.

This script may ask for your administrator password (if you have not recently authenticated),
and will update a single file  (/System/Library/LaunchDaemons/com.apple.mDNSResponder.plist)
before restarting the name resolution system on this machine.

If it aborts, please contact the Brilliant Desk or Equanet (0845 37 01 889) for further support.
Originally written by Mike Thomson (michael.thomson@ee.co.uk, 07977 415 639)

!EOD

LIBFILE="/System/Library/LaunchDaemons/com.apple.mDNSResponder.plist"
LOCALCOPY="./com.apple.mDNSResponder.plist.original"
LOCALEDIT="./com.apple.mDNSResponder.plist.new"

sudo cp -a ${LIBFILE} ${LOCALCOPY}

cp ${LOCALCOPY} ${LOCALEDIT}

sed -E '/<string>-AlwaysAppendSearchDomains<\/string>/ d' ${LOCALCOPY} > ${LOCALEDIT}

if [ $? -ne 0 ]; then 
{
  echo "File patching failed. Aborting"
  exit 255
}
fi

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

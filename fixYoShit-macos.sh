#!/bin/bash
# Generic macOS shizzle that might fix shit
# (or at least give the user the impression that things are getting fixed..)

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root, use  "$0" instead" 1>&2
   exit 1
fi


# Rebuild XPC caches
 /usr/libexec/xpchelper --rebuild-cache

# Rebuild CoreDuet database
 rm -fr /var/db/coreduet/*

# Rebuild Launch Services Database
 /System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister -kill -r -seed -domain local -domain system -domain user

# Flush DNS cache and restart mDNSResponder
 dscacheutil -flushcache &&  killall -HUP mDNSResponder

# Delete BootCache
 rm -f /private/var/db/BootCache.playlist

# Update dyld shared cache
 update_dyld_shared_cache -root / -force

# Rebuild Kernel extension caches
 touch /System/Library/Extensions &&  kextcache -u /

# Run all periodic system scripts
 periodic daily weekly monthly


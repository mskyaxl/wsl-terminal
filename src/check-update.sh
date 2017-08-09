#!/bin/bash

cygwin_version="$(curl http://mirrors.kernel.org/sourceware/cygwin/x86_64/release/cygwin/md5.sum \
    2>/dev/null | grep -Po '\d\.\d\.\d-\d' | tail -n 1)"

mintty_version="$(curl http://mirrors.kernel.org/sourceware/cygwin/x86_64/release/mintty/md5.sum \
    2>/dev/null | grep -Po '\d\.\d\.\d-\d' | tail -n 1)"

wslbridge_version="$(curl https://github.com/rprichard/wslbridge/releases \
    2>/dev/null | grep -Po '\d\.\d\.\d-cygwin64\.tar\.gz' | cut -d- -f1 | head -n 1)"

cbwin_version="$(curl https://github.com/xilun/cbwin/releases \
    2>/dev/null | grep -Po '\d\.\d\d\.zip' | head -n 1 | sed 's/\.zip//g')"

sed -i -e "s/^cygwin_version=.*$/cygwin_version=\"$cygwin_version\"/g" \
    -e "s/^mintty_version=.*$/mintty_version=\"$mintty_version\"/g" \
    -e "s/^wslbridge_version=.*$/wslbridge_version=\"$wslbridge_version\"/g" \
    -e "s/^cbwin_version=.*$/cbwin_version=\"$cbwin_version\"/g" \
    prepare.sh

index=1

git diff | grep "^+mintty_version" >/dev/null \
    && echo "$((index++)).Upgrade mintty to [${mintty_version%-*}](https://github.com/mintty/mintty/releases/tag/${mintty_version%-*})."

git diff | grep "^+wslbridge_version" >/dev/null \
    && echo "$((index++)).Upgrade wslbridge to [$wslbridge_version](https://github.com/rprichard/wslbridge/releases/tag/$wslbridge_version)."

git diff | grep "^+cbwin_version" >/dev/null \
    && echo "$((index++)).Upgrade cbwin to [$cbwin_version](https://github.com/xilun/cbwin/releases/tag/v$cbwin_version)."

exit 0

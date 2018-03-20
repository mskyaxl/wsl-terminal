#!/bin/bash

cygwin_version="$(curl http://mirrors.kernel.org/sourceware/cygwin/x86_64/release/cygwin/sha512.sum \
    2>/dev/null | grep -Po '\d\.\d\d\.\d-\d' | tail -n 1)"

mintty_version="$(curl http://mirrors.kernel.org/sourceware/cygwin/x86_64/release/mintty/sha512.sum \
    2>/dev/null | grep -Po '\d\.\d\.\d-\d' | tail -n 1)"

wslbridge_version="$(curl https://github.com/rprichard/wslbridge/releases \
    2>/dev/null | grep -Po '\d\.\d\.\d-cygwin64\.tar\.gz' | cut -d- -f1 | head -n 1)"

sed -i -e "s/^cygwin_version=.*$/cygwin_version=\"$cygwin_version\"/g" \
    -e "s/^mintty_version=.*$/mintty_version=\"$mintty_version\"/g" \
    -e "s/^wslbridge_version=.*$/wslbridge_version=\"$wslbridge_version\"/g" \
    prepare.sh

index=1

git diff | grep "^+mintty_version" >/dev/null \
    && echo "$((index++)).Upgrade mintty to [${mintty_version%-*}](https://github.com/mintty/mintty/releases/tag/${mintty_version%-*})."

git diff | grep "^+wslbridge_version" >/dev/null \
    && echo "$((index++)).Upgrade wslbridge to [$wslbridge_version](https://github.com/rprichard/wslbridge/releases/tag/$wslbridge_version)."

exit 0

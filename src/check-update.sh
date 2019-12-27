#!/bin/bash

cygwin_version="$(curl http://mirrors.kernel.org/sourceware/cygwin/x86_64/release/cygwin/sha512.sum \
    2>/dev/null | grep -Po '\d\.\d*\.\d-\d' | tail -n 1)"

mintty_version="$(curl http://mirrors.kernel.org/sourceware/cygwin/x86_64/release/mintty/sha512.sum \
    2>/dev/null | grep -Po '\d\.\d\.\d-\d' | tail -n 1)"

wslbridge2_version="$(curl https://github.com/Biswa96/wslbridge2/releases \
    2>/dev/null | grep -Po 'wslbridge2\/releases\/tag\/v\d\.\d' | cut -dv -f2 | head -n 1)"

sed -i -e "s/^cygwin_version=.*$/cygwin_version=\"$cygwin_version\"/g" \
    -e "s/^mintty_version=.*$/mintty_version=\"$mintty_version\"/g" \
    -e "s/^wslbridge2_version=.*$/wslbridge2_version=\"$wslbridge2_version\"/g" \
    prepare.sh

index=1

git diff | grep "^+mintty_version" >/dev/null \
    && echo "$((index++)).Upgrade mintty to [${mintty_version%-*}](https://github.com/mintty/mintty/releases/tag/${mintty_version%-*})."

git diff | grep "^+wslbridge2_version" >/dev/null \
    && echo "$((index++)).Upgrade wslbridge2 to [${wslbridge2_version}](https://github.com/Biswa96/wslbridge2/releases/tag/${wslbridge2_version})."

exit 0

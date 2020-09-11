#!/bin/bash


set -e

usage() {
      echo "build.sh [-v <version>] [-t] [-u <existing folder>]"
      echo "Options:"
      echo "-v <version> version to be installed(latest is default)"
      echo "-t  installs the tabbed version"
      echo "-u <folder> version to be installed(latest is default)"
}
version=""
tabbed=0
foldername=""
emoji_support=0
semanticVersion_reqex=".*(^[0-9]+\.[0-9]+\.[0-9]+)(-[0-9A-Za-z]+)*(_(tabbed))*$.*"

scriptpath="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd "$scriptpath"
while getopts "htv:u:" opt; do
  case ${opt} in
    h )
        usage;
        exit 0
      ;;
    t )
        tabbed=1
      ;;
    v )
      version=$(echo ${OPTARG} | sed -rn 's/'$semanticVersion_reqex'/\1/p')
      if [[ "$version" == "" ]]; then
        echo "Invalid verion: -$version" 1>&2
        exit 1
      fi
      ;;
    u )
      existing_install_folder=${OPTARG}
      if [[ ! -d $existing_install_folder ]]; then
        echo "folder does not exist: - $existing_install_folder" 1>&2
        exit 1
      fi
      ;;
    \? )
      echo "Invalid Option: -$OPTARG" 1>&2
      exit 1
      ;;
  esac
done

if [ "$version" == "" ]; then
    version=$(wget -nc https://raw.githubusercontent.com/mskyaxl/wsl-terminal/master/VERSION -O - 2>/dev/null)
fi

if [ "$existing_install_folder" != "" ]; then
    tabbed=0
    cd $existing_install_folder
    curent_version=$(cat VERSION | sed -rn 's/'$semanticVersion_reqex'/\1/p')
    variant=$(cat VERSION | sed -rn 's/'$semanticVersion_reqex'/\4/p')
    echo Checking the latest version ...
    if [[ "$curent_version" == "$version" ]]; then
        echo Already the latest version: $version
        exit
    fi

    echo -n "Upgrade [$curent_version] to [$version]? (y/n)"
    read -n1 answer 
    if [ "$answer" != "y" ]; then
        exit
    fi
    printf "\n"
    if [ "$variant" == "tabbed" ]; then
        echo "tabbed version detected"
        tabbed=1
    fi

fi

if [ "$(which 7z)" == "" ]; then
    echo "7z command not found."
    echo "install 7z in wsl"
    echo "ubuntu: sudo apt install p7zip-full"
    echo "Archlinux: pacman -S p7zip"
    exit 1
fi 

if [ $tabbed == 1 ]; then
    filename=wsl-terminal-tabbed-$version.7z
    ttyrcfile=fattyrc
    foldername=wsl-terminal-tabbed
    emoji_support=0
else
    filename=wsl-terminal-$version.7z
    ttyrcfile=minttyrc
    foldername=wsl-terminal
    emoji_support=1
fi

printf "downloading $filename ..."
if [ ! -e "$filename" ]; then
    wget -nc "https://github.com/mskyaxl/wsl-terminal/releases/download/v$version/$filename"  > /dev/null 2>&1
fi
printf "done\n"

rm -rf $foldername
printf "extracting(this might take a while)..."
7z x "$filename"  > /dev/null 2>&1 || {
    echo "$filename is broken, try again."
    rm -v "$filename"
    exit 1
}
printf "done\n"

if [ "$existing_install_folder" != "" ]; then
    printf "updating."
    mv $foldername/tools/* tools/
    printf "."
    mv $foldername/etc/wsl-terminal.conf etc/wsl-terminal.conf.pacnew
    mv $foldername/etc/$ttyrcfile etc/$ttyrcfile.pacnew
    mv $foldername/etc/lang/* etc/lang/
    printf "."
    if [[ emoji_support == 1 ]]; then
      mkdir -p etc/emojis/openmoji
      printf "."
      mv $foldername/etc/emojis/openmoji/* etc/emojis/openmoji/
    fi

    printf "."
    mv $foldername/etc/themes/* etc/themes/
    mv $foldername/etc/README.md etc/

    cd $foldername/bin
    for i in *; do
        mv "../../bin/$i" "../../bin/$i.$$.bak"
        mv "$i" "../../bin/$i"
        rm -f ../../bin/*.bak 2>/dev/null || true
    done
    cd ../..

    rm -rf doc
    mv $foldername/doc .
    mv $foldername/{*.*,cmdtool,VERSION} .

    printf "done\n"
    rm -rf $foldername
fi

rm "$filename"
exit

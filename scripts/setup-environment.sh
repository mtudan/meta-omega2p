#!/bin/sh
# Setup bblayers.conf and local.conf

RED='\033[1;31m'   # Red color
GREEN='\033[1;32m' # Green color
BLUE='\033[1;34m'  # Blue color
NC='\033[0m'       # No color

# List of supported targets
targets="omega2p"

# File names
bn=$(basename $0)
BBLAYERS="conf/bblayers.conf"
LOCALCFG="conf/local.conf"
SANITYCFG="conf/sanity_info"

# Keeping the original files
BBLAYERSBAK="$BBLAYERS.bak"
LOCALCFGBAK="$LOCALCFG.bak"

help() {
	echo
	echo -e "${BLUE} Usage: \"$bn <TARGET>\"${NC}"
	echo
	echo " TARGET: $targets"
	echo

	exit 1
}

# Check if target is supported
target_check() {
	[[ $targets =~ (^|[[:space:]])"$1"($|[[:space:]]) ]] && TARGET="$1" || help
}

# Check if argument is passed to script
[ -n "$1" ] && target_check $1 || help

SOURCES_PATH=$(grep sources $BBLAYERS | head -n 1)
SOURCES_PATH=$(echo $SOURCES_PATH | rev | cut -d'/' -f3- | rev)

# Save original files
if [ ! -f $BBLAYERSBAK ]; then
	cp "$BBLAYERS" "$BBLAYERSBAK"
fi
if [ ! -f $LOCALCFGBAK ]; then
	cp "$LOCALCFG" "$LOCALCFGBAK"
fi

# Restore original files
cp "$BBLAYERSBAK" "$BBLAYERS"
cp "$LOCALCFGBAK" "$LOCALCFG"

# Set sanity check configuration
echo "SANITY_VERSION 1" > $SANITYCFG
echo "TMPDIR $PWD/tmp" >> $SANITYCFG
echo "SSTATE_DIR $PWD/sstate-cache" >> $SANITYCFG
DISTRO=`grep "^ID=" /etc/os-release` && DISTRO=${DISTRO#ID=}
DISTRO_VER=`grep "^VERSION=" /etc/os-release` && DISTRO_VER=${DISTRO_VER#VERSION=}
DISTRO_VER=$(echo $DISTRO_VER | cut -d '"' -f 2)
if [ -n "$DISTRO_VER" ]; then
	DISTRO=$DISTRO-$DISTRO_VER
fi
echo "NATIVELSBSTRING $DISTRO" >> $SANITYCFG

# Set custom config in "conf/local.conf"
sed -i '1i RM_OLD_IMAGE = "1"\n' $LOCALCFG
sed -i '1i # Remove previously built versions of the same image from the deploy dir' $LOCALCFG
sed -i '1i DISTRO = "omega2p"\n' $LOCALCFG
sed -i '1i # meta-omega2p distro' $LOCALCFG
sed -i "1i MACHINE = \"$TARGET\"\n" $LOCALCFG
sed -i '1i # meta-omega2p machine' $LOCALCFG

# Append custom layers in "conf/bblayers.conf"
sed -i '$ d' $BBLAYERS # Remove last line
echo "  $SOURCES_PATH/meta-$TARGET \\" >> $BBLAYERS
echo "\"" >> $BBLAYERS

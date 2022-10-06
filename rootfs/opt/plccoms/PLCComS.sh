#!/bin/sh
#
# PLCComS.sh
#
# (C)opyright Teco a.s.
#
# 2019/11/05 Hosek Martin <hosek@tecomat.cz>
#

ARCH=`uname -m`

LOGFILE="/var/log/PLCComS.log"

case $ARCH in
    i586|i686) PLCCOMS="PLCComS"
	       LIBSDIR="lib_x86"
	       ;;
    x86_64)    PLCCOMS="PLCComS_x86_64"
	       LIBSDIR="lib_x86_64"
	       ;;
    armv6l)    PLCCOMS="PLCComS_arm_eabihf"
	       LIBSDIR="lib_rpi"
	       ;;
    armv7l)    PLCCOMS="PLCComS_arm_eabihf"
	       LIBSDIR="lib_rpi2"
	       ;;
    aarch64)   PLCCOMS="PLCComS_aarch64"
	       LIBSDIR=""
	       ;;
    *)         echo "Unknown or unsupporten architecture: $ARCH"
	       exit 1
	       ;;
esac

export LD_LIBRARY_PATH=$LIBSDIR

echo
echo "ARCH: $ARCH"
echo

killall -9 "$PLCCOMS" >/dev/null 2>&1

sleep 1

export MALLOC_CHECK_=4

if [ ! -x ./$PLCCOMS ]; then
    chmod +x ./$PLCCOMS
fi

while true; do

    ./$PLCCOMS -t #> "$LOGFILE" 2>&1

    sleep 1
done

exit 0

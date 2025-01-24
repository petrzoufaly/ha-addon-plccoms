#!/bin/bash
#
# Install.sh
#
# (C)opyright Teco a.s.
#
# 2019/05/02 Hosek Martin <hosek@tecomat.cz>
#

INSTDIR=`pwd`
LOGFILE="/var/log/PLCComS.log"
RCLOCAL="/etc/rc.local"

Help()
{
    echo "  Usage: $(basename $0) [-i|-u|-h]"
    echo
    echo "  -i  Install"
    echo "  -u  Uninstall"
    echo "  -h  This help message"

    exit 1
}

while getopts "iuh" opt; do
    case "$opt" in
	i) action="INSTALL"
	   ;;
	u) action="UNINSTALL"
	   ;;
	*) Help
	   ;;
    esac
done

if [ ! "$*" ]; then
    Help
    exit 1
fi

if [ "$EUID" != "0" ]; then
    echo "You must be a root!"
    exit 1
fi

case "$action" in
    INSTALL)	echo "Installing..."
		echo

		echo "Setting file attributes for:"
		echo
		for f in PLCComS*; do
		    if [ "$f" != "PLCComS.ini" ]; then
			echo " $f"
			chmod +x "$f"
		    fi
		done

		echo
		echo -n "Setting PLCComS as service: "

		if grep -q "^# PLCComS" "$RCLOCAL"; then
		    echo "Record is exist."
		else
		    echo "Adding record to $RCLOCAL"
		    sed -i /'^exit 0'/d "$RCLOCAL"
		    APPEND="# PLCComS\necho \"Starting PLCComS server...\"\ncd ${INSTDIR}\n./PLCComS.sh > $LOGFILE 2>&1 &\n\nexit 0"
		    echo "--------------"
		    echo -e "$APPEND" | sed /'^$'/,/'^exit 0'/d
		    echo "--------------"
		    echo -e "$APPEND" >> "$RCLOCAL"
		fi

		echo
		echo "Installation done."
		;;
    UNINSTALL)	echo "Uninstall..."
		echo

		if grep -q "^# PLCComS" "$RCLOCAL"; then
		    echo "Removing record from $RCLOCAL"
		    sed -i /'^# PLCComS'/,/'^$'/d "$RCLOCAL"
		    echo
		fi

		echo "Uninstallation done."
		;;
    *) 		Help
		;;
esac

exit 0

#!/bin/bash
# skrypt do kopiowania logów httpd z Home.pl
# Tomasz Klim, luty 2013, grudzień 2014


if [ "$1" = "" ]; then
	WHEN="-1 day"
else
	WHEN=$1
fi

YMSUB="`date +%Y/%m -d \"$WHEN\"`"
YMD="`date +%Y%m%d -d \"$WHEN\"`"


ROOT="/srv/apps/hosting"

if [ ! -d $ROOT ]; then
	mount | mail -s "Nie wykonano replikacji logów z Home.pl dnia $YMD, dysk nie zamontowany" homepl-fetch-notify@tomaszklim.pl
	exit
fi


declare -A ACCOUNTS=(
	[apiekspert]="statsXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
)


for ACC in "${!ACCOUNTS[@]}"; do
	LOGURL="http://$ACC.home.pl/${ACCOUNTS[$ACC]}"
	LOGDIR="$ROOT/$ACC/$YMSUB"
	LOGFILE="statslog.$YMD.txt"

	mkdir -p $LOGDIR
	wget -O "$LOGDIR/$LOGFILE" -a $LOGDIR/wget.log -t inf "$LOGURL/logs/web.log.$YMD.txt"

	mv "$LOGDIR/$LOGFILE" "$LOGDIR/$LOGFILE.gz"
	gzip -d "$LOGDIR/$LOGFILE.gz"

	if [ "$ACC" = "apiekspert" ]; then
		/etc/local/sync/homepl-akomail.sh $LOGDIR $LOGFILE
	fi

	ls -lR $ROOT/$ACC | mail -s "Podsumowanie replikacji logów $ACC z Home.pl dnia $YMD" homepl-fetch-notify@tomaszklim.pl
done

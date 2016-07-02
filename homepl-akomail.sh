#!/bin/sh
# skrypt do powiadamiania instancji AkoMaila o otwarciach
# maili znalezionych w logu ściągniętym z konta Home.pl
# Tomasz Klim, luty 2014

DIR=$1
LOG=$2

INSTANCES="
akomail-01.tomaszklim.pl
akomail-02.tomaszklim.pl
akomail-03.tomaszklim.pl
akomail-04.tomaszklim.pl
"

for ID in `cat "$DIR/$LOG" |grep /wp-tanibackup/akomail.jpg |grep mailing |cut -d " " -f 7 |cut -d "=" -f 3`; do
	wget -a $DIR/akomail.log -t 3 -O /dev/null http://akomail-01.tomaszklim.pl/newsletter/stat/mailing/$ID.jpg
done

for ID in `cat "$DIR/$LOG" |grep /wp-lexfactory/akomail.jpg |grep mailing |cut -d " " -f 7 |cut -d "=" -f 3`; do
	wget -a $DIR/akomail.log -t 3 -O /dev/null http://akomail-02.tomaszklim.pl/newsletter/stat/mailing/$ID.jpg
done

for ID in `cat "$DIR/$LOG" |grep /wp-erphosting/akomail.jpg |grep mailing |cut -d " " -f 7 |cut -d "=" -f 3`; do
	wget -a $DIR/akomail.log -t 3 -O /dev/null http://akomail-03.tomaszklim.pl/newsletter/stat/mailing/$ID.jpg
done

for ID in `cat "$DIR/$LOG" |grep /akomail-fake-dir-for-logs |grep mailing |cut -d " " -f 7 |cut -d "/" -f 6`; do
	wget -a $DIR/akomail.log -t 3 -O /dev/null http://akomail-02.tomaszklim.pl/newsletter/stat/mailing/$ID
done

for ID in `cat "$DIR/$LOG" |grep /akomail3-fake-dir-for-logs |grep mailing |cut -d " " -f 7 |cut -d "/" -f 6`; do
	wget -a $DIR/akomail.log -t 3 -O /dev/null http://akomail-03.tomaszklim.pl/newsletter/stat/mailing/$ID
done

for ID in `cat "$DIR/$LOG" |grep /akomail4-fake-dir-for-logs |grep mailing |cut -d " " -f 7 |cut -d "/" -f 6`; do
	wget -a $DIR/akomail.log -t 3 -O /dev/null http://akomail-04.tomaszklim.pl/newsletter/stat/mailing/$ID
done

for INSTANCE in $INSTANCES; do
	for ID in `cat "$DIR/$LOG" |grep /wp-legalnymailing/track.jpg |grep $INSTANCE |grep mailing |cut -d " " -f 7 |cut -d "=" -f 4`; do
		wget -a $DIR/akomail.log -t 3 -O /dev/null http://$INSTANCE/newsletter/stat/mailing/$ID.jpg
	done
done

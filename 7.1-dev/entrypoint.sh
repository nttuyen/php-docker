#!/bin/bash

## Make www-data user can write on folder /var/www/html
OWNER_USER_ID=$(stat -c "%u" /var/www)
OWNER_GROUP_ID=$(stat -c "%g" /var/www)

if [ "$OWNER_USER_ID" == "0" ] ; then
	chown www-data:www-data -R /var/www
else
	usermod -u $OWNER_USER_ID www-data | true
	groupmod -g $OWNER_GROUP_ID www-data | true
fi


### Support installer
if [ ! -f /docker_installed ] ; then
	for f in /installer.d/*
	do
		if [[ -x "$f" ]]
		then
		    echo "$0: running $f"; . "$f" ;
		fi
		echo
	done

	touch /docker_installed
fi

### Support start
for f in /startup.d/*
do
	if [[ -x "$f" ]]
	then
	    echo "$0: running $f"; . "$f" ;
	fi
	echo
done

#############################
# Note: we don't just use "apache2ctl" here because it itself is just a shell-script wrapper around apache2 which provides extra functionality like "apache2ctl start" for launching apache2 in the background.
# (also, when run as "apache2ctl <apache args>", it does not use "exec", which leaves an undesirable resident shell process)

: "${APACHE_CONFDIR:=/etc/apache2}"
: "${APACHE_ENVVARS:=$APACHE_CONFDIR/envvars}"
if test -f "$APACHE_ENVVARS"; then
	. "$APACHE_ENVVARS"
fi

# Apache gets grumpy about PID files pre-existing
: "${APACHE_PID_FILE:=${APACHE_RUN_DIR:=/var/run/apache2}/apache2.pid}"
rm -f "$APACHE_PID_FILE"

exec apache2 -DFOREGROUND
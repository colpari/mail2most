#!/bin/bash

set -e

# execute command if given
test -n "$@" && exec $@

M2M_CONFFILE="${M2M_CONFFILE:-/mail2most/state/mail2most.conf}"
M2M_CONFDIR="${M2M_CONFDIR:-/mail2most/conf/}"
M2M_CONF_PREAMBLE="${M2M_CONF_PREAMBLE:-$M2M_CONFDIR/.preamble}"

echo "[config] preamble='$M2M_CONF_PREAMBLE,' dir='$M2M_CONFDIR', output='$M2M_CONFFILE'"

if test -s "$M2M_CONFFILE"
then
	echo "[config] WARNING : '$M2M_CONFFILE' exists and is not empty - overwriting"
fi


cat "$M2M_CONF_PREAMBLE" > "$M2M_CONFFILE"

chmod 600 "$M2M_CONFFILE"

for f in "$M2M_CONFDIR"/*.toml
do
	if test -f "$f"
	then
		echo "[config] adding config file '$f'"
		cat "$f" >> "$M2M_CONFFILE"
	fi
done

if ! test -s "$M2M_CONFFILE"
then
	echo "[config] no or only empty configuration(s) found" 1>&2
	exit 1
fi

cd /mail2most

exec ./mail2most -c "$M2M_CONFFILE"

#!/bin/bash

set -e

# execute command if given
test -n "$@" && exec $@

M2M_CONFFILE="${M2M_CONFFILE:-/mail2most/conf/mail2most.conf}"

if test -s "$M2M_CONFFILE"
then
	echo "[config] WARNING : '$M2M_CONFFILE' exists and is not empty - overwriting"
fi

M2M_CONF_PREAMBLE="${M2M_CONF_PREAMBLE:?}"

cat "$M2M_CONF_PREAMBLE" > "$M2M_CONFFILE"

echo "[config] preamble is '$M2M_CONF_PREAMBLE'"

for f in /mail2most/conf.d/*.toml
do
	if test -f "$f"
	then
		echo "[config] adding config file '$f'"
		cat "$f" >> "$M2M_CONFFILE"
	fi
done

if ! test -s "$M2M_CONFFILE"
then
	echo "[config] no configuration(s) found" 1>&2
	exit 1
fi

cd /mail2most

exec ./mail2most -c "$M2M_CONFFILE"

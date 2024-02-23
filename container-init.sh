#!/bin/bash

set -e

# execute command if given
test -n "$@" && exec $@

M2M_CONFFILE="${M2M_CONFFILE:-/mail2most/state/mail2most.conf}"
M2M_CONFDIR="${M2M_CONFDIR:-/mail2most/conf/}"
M2M_CONF_PREAMBLE="${M2M_CONF_PREAMBLE:-$M2M_CONFDIR/.preamble}"

echo "[config] preamble='$M2M_CONF_PREAMBLE,' input='$M2M_CONFDIR', output='$M2M_CONFFILE'"
echo "[config] writing '$M2M_CONFFILE'"

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
	echo -e "[config] no or only empty configuration(s) found?\n[config] ABORTING" 1>&2
	exit 1
fi

# just 2b sure:
chmod 600 "$M2M_CONFFILE"

cd /mail2most

exec ./mail2most -c "$M2M_CONFFILE"

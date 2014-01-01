#!/bin/bash
set -e

BACKUPDIR="$1"
if [ -z "$BACKUPDIR" ]; then
    echo "please specify the backup directory"
fi
# use basename in order to make backuptype better readable
BACKUPTYPES=$(find ${BACKUPDIR} -maxdepth 1 -mindepth 1 -type d -exec basename {} \;)
KEEP_DAYS=30
LOGTAG=$(basename $0)

cd "$BACKUPDIR"
for dir in $BACKUPTYPES; do
	# ensure that at least one backup is kept
	if [ $(find "$dir" -maxdepth 1 -mindepth 1 -type d | wc -l) -lt 2 ]; then
        logger -t $LOGTAG "only 1 backup of type $dir found, keeping it"
        continue
	fi

    find "$dir" -maxdepth 1 -mindepth 1 -type d -mtime $KEEP_DAYS -exec logger -t $LOGTAG "removing {}" \; -exec rm -rf {} \;
done

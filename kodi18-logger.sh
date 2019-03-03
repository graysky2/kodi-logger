#!/bin/bash
LOG=/var/lib/kodi/.kodi/temp/kodi.log
TMP=/tmp
TMPDB="$TMP/uniques"
FINAL="/var/log/kodi-watched.log"

if [[ ! -f "$FINAL" ]]; then
	if ! touch "$FINAL"; then
		echo " Cannot make the empty file $FINAL"
		exit 1
	fi
fi

if [[ ! -w "$FINAL" ]]; then
	echo " Cannot write to $FINAL so modify the permissions on it and try again."
	exit 1
fi

if [[ -f "$TMPDB.db" ]]; then
	# already ran once so just see what if anything is new and capture the diffs
	# credit to the following post for the sed line:
	# https://unix.stackexchange.com/questions/24140/return-only-the-portion-of-a-line-after-a-matching-pattern
	sed -n -e 's/^.*VideoPlayer::OpenFile: //p' "$LOG" | sed 's/ /_/g' | sort | uniq > "$TMPDB".2
	comm -13 "$TMPDB".db "$TMPDB".2 > "$TMP"/diff.db
	< "$TMP"/diff.db gawk '{ print strftime("%a %b %e %H:%M:%S %Y"), $0 }' >> "$FINAL"

	mv "$TMPDB".2 "$TMPDB".db
	rm -f "$TMP/diff".db
else
	# first time so capture all entries
	sed -n -e 's/^.*VideoPlayer::OpenFile: //p' "$LOG" | sed 's/ /_/g' | sort | uniq > "$TMPDB.db"
	< "$TMPDB.db" gawk '{ print strftime("%a %b %e %H:%M:%S %Y"), $0 }' >> "$FINAL"
fi

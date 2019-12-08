#!/bin/bash
LOG=/var/lib/kodi/.kodi/temp/kodi.log
FINAL=/var/log/kodi-watched.log
TMP=/tmp
TMPDB="$TMP/uniques"

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

process() {
	awk '{ print $1 " " $2 }' <"$TMP"/whole.slice > "$TMP"/dates.slice
	sed -n -e 's/^.*VideoPlayer::OpenFile: //p' <"$TMP"/whole.slice > "$TMP"/names.slice

	# convert dates from log
	while IFS=',' read -ra arr; do
		printf "%s\n" "$(date -d "${arr[0]}" '+%a %b %e %r %Y')"
	done < "$TMP"/dates.slice > "$TMP"/rightdates.slice
}

if [[ -f "$TMPDB".db ]]; then
	grep '^.*VideoPlayer::OpenFile:' "$LOG" > "$TMP/maybe.slice"

	# is new snapshot is different from last time? die if so
	if cmp -s "$TMP/maybe.slice" "$TMP/whole.slice"; then
		rm -f "$TMP/maybe.slice"
	else
		# compare and only write out new entries
		mv "$TMP/maybe.slice" "$TMP/whole.slice"
		process
		paste -d ' ' "$TMP"/rightdates.slice "$TMP"/names.slice > "$TMPDB".2
		comm -13 "$TMPDB".db "$TMPDB".2 >> "$FINAL"
		mv "$TMPDB".2 "$TMPDB".db
	fi
else
	# first time so capture all entries
	grep '^.*VideoPlayer::OpenFile:' "$LOG" > "$TMP/whole.slice"
	process
	paste -d ' ' "$TMP"/rightdates.slice "$TMP"/names.slice > "$TMPDB".db
	cat "$TMPDB".db >> "$FINAL"
fi

rm -f "$TMP"/diff.db "$TMP"/dates.slice "$TMP"/names.slice "$TMP"/rightdates.slice

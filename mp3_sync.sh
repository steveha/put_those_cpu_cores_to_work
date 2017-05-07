#!/bin/bash

USAGE="usage: mp3_sync <flac_dir> <mp3_dir> <sub_dir_with_music>"

case x$1 in
	x) >&2 echo $USAGE; exit 1;;
	x-h) >&2 echo $USAGE; exit 1;;
	x--help) >&2 echo $USAGE; exit 1;;
esac

SRC_DIR=`readlink -f "$1/$3"`
DEST_DIR=`readlink -f "$2/$3"`
TMP_DIR=`dirname $(mktemp -u)`

cd "$SRC_DIR"
mkdir -p "$DEST_DIR"
for fname in *.flac; do
	SRC_FILE="$SRC_DIR/$fname"
	DEST_FILE="$DEST_DIR/${fname%%.flac}.mp3" 
	TEMP_FILE="$TMP_DIR/mp3_sync$$.wav"
	#echo "$SRC_FILE -> $DEST_FILE ($TEMP_FILE)"
	if [ -e "$DEST_FILE" ] ; then
		#echo "Skipping $DEST_FILE"
		continue
	fi
	flac -d -f --totally-silent "$fname" -o "$TEMP_FILE"
	if [ $? -ne 0 ]; then
		echo "FLAC decode failed on: $SRC_FILE" 1>&2
		exit $?
	fi
    lame -Shv "$TEMP_FILE" "$DEST_FILE" 2> /dev/null
	if [ $? -ne 0 ]; then
		echo "MP3 encode failed on: $TEMP_FILE" 1>&2
		exit $?
	fi
	rm -f "$TEMP_FILE"
done

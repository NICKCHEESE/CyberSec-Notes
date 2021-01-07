#!/bin/bash
#
# This is a script to quickly decompress nested archive files for CTF challenges
# I.E. A zip inside of a tar inside of a bzip inside of a gzip inside of a 7z
# 
# Credit for the orginial idea and script goes to John Hammond
# https://www.youtube.com/watch?v=wRSwagjvSqU
# 
# I just modified it to use 7z and cleaned it up a bit for general purpose 

filename=$1

rm -r tmp
mkdir tmp
cp $filename tmp

cd tmp


while [ 1 ] 
do
	file $filename

	file $filename | grep -i "zip"

	if [ "$?" -eq "0" ]
	then
		echo "This is a compressed file..."
		mv $filename $filename.7z
		7z e $filename.7z
		rm $filename.7z
		filename=$(ls *)
	fi

	file $filename | grep "tar"

	if [ "$?" -eq "0" ]
	then
		echo "This is a tarball..."
		mv $filename $filename.tar
		7z e $filename.tar
		rm $filename.tar
		filename=$(ls *)

	fi


	file $filename | grep "ASCII"

	if [ "$?" -eq "0" ]
	then
		echo "This is ASCII text..."
		cat $filename
		break
	fi

done
#!/usr/bin/bash

files=$(ls *.md);

for file in $files
do
    awk '/^date:/ { print "layout: post"; print; next}1' $file > temp_$file
    mv temp_$file $file
done

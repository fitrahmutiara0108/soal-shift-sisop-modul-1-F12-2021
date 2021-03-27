#!/bin/bash

cd $(dirname $0)

yesterday=$(date -d yesterday +"%d-%m-%Y")
today=$(date +"%d-%m-%Y")

if [ -d "Kucing_$yesterday" ]
then
    download="bunny"
    folderName="Kelinci_$today"
else
    download="kitten"
    folderName="Kucing_$today"
fi

fileNum=1
i=1
while [ $i -le 23 ]
do
	if [ $i -lt 10 ]
	then
		fileName="Koleksi_0$fileNum.jpg"
	else
		fileName="Koleksi_$fileNum.jpg"
	fi
	
	wget -O "$fileName" -a Foto.log "https://loremflickr.com/320/240/$download"
	
	j=1
	while [ $j -lt $i ]
	do
		if [ $j -lt 10 ]
		then
			cmpFile="Koleksi_0$j.jpg"
		else
			cmpFile="Koleksi_$j.jpg"
		fi
		
		cmp $fileName $cmpFile
		status=$?
		
		if [ $status -eq 0 ]
		then
			rm $fileName
			fileNum=$((fileNum-1))
			break
		fi
		j=$((j+1))
	done
	
	fileNum=$((fileNum+1))
	i=$((i+1))
done

mkdir "$folderName"
mv ./Koleksi_* "./$folderName/"
mv ./Foto.log "./$folderName/"
#!/bin/bash

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
	
	wget -O "$fileName" -a Foto.log https://loremflickr.com/320/240/kitten
	
	check_eq=1
	awk_array=($(awk '/https:\/\/loremflickr.com\/cache\/resized\// {print $3}' ./Foto.log))

	j=0
	while [ $j -lt $(($i-1)) ]
	do
		if [ "${awk_array[j]}" == "${awk_array[$(($i-1))]}" ]
		then
			echo "SAMA"
			check_eq=0
		fi

		if [ $check_eq -eq 0 ]
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
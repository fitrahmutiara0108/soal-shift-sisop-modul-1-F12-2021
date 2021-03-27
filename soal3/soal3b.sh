#!/bin/bash

cd $(dirname $0)
bash ./soal3a.sh

folderName=$(date +"%d-%m-%Y")
mkdir "$folderName"

mv ./Koleksi_* "./$folderName/"
mv ./Foto.log "./$folderName/"
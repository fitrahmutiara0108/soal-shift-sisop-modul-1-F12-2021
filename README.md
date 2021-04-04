# Soal Shift Modul 1 Sisop 2021 (Kelompok F12)
#### Nama anggota kelompok:
- Farhan Arifandi (05111940000061)
- Fitrah Mutiara (05111940000126)
- M. Iqbal Abdi (05111940000151)

## Soal 1
### Poin (a)
Mengumpulkan informasi jenis log (ERROR/INFO), pesan log, dan username pada setiap baris lognya dari file syslog.log dengan regex (regular expression). Hasil dimasukkan ke file logTest.txt.
Command:
- -o mencetak bagian dari baris yang sesuai dengan pola (Regex: INFO/ERROR diikuti spasi dan apapun hingga akhir baris).
- -E menandakan bahwa pola yang diberikan merupakan extended regex pattern.
- Output dicetak ke dalam file logTest.txt untuk debug (tidak ada dalam soal, tetapi output command tidak muncul di terminal).
```
grep -oE 'INFO\s.*|ERROR\s.*' syslog.log > logTest.txt
```

Contoh output 1(a) pada file **logTest.txt** -- total 100 baris.<br>
[![logTest.txt](https://iili.io/qUvYAl.md.png)](https://iili.io/qUvYAl.png)

### Poin (b)
Menampilkan semua pesan error yang muncul beserta jumlah kemunculannya.
Command:
- -o mencetak bagian dari baris yang sesuai dengan pola (Regex: ERROR diikuti spasi, lalu pola huruf besar diikuti huruf kecil, dan maksimal 6 kata berikutnya).
- -E menandakan bahwa pola yang diberikan merupakan extended regex pattern.
- -c menghitung jumlah baris yang berisi "ERROR"
```
grep -oE "ERROR\s([A-Z])([a-z]+)(\s[a-zA-Z']+){1,6}" syslog.log;
printf "Total: %d\n" $(grep -c "ERROR" syslog.log);
```
Output 1(b) di terminal:<br>
[![Output 1b](https://iili.io/qUv0o7.md.png)](https://iili.io/qUv0o7.png)

### Poin (c)
Menampilkan jumlah kemunculan log ERROR dan INFO untuk setiap user.
Command:
- cut memotong baris dari awal hingga ditemukan '(' sebagai delimiter, lalu hasilnya dipotong hingga ditemukan ')', menghasilkan string berupa username pengguna.
- -d menandakan delimiter/batas antar field pada baris.
- sort mengurutkan baris hasil cut secara ascending, dan uniq mengabaikan baris duplikat.
- grep menampilkan jumlah baris yang sesuai pola (Regex: INFO/ERROR diikuti apapun, dengan username yang sedang diiterasi di akhir baris, `\b` untuk pembatas agar username yang diambil tepat sesuai dengan username yang sedang diiterasi)
- Baris yang dicetak menampilkan username dan jumlah error/info.
```
userList=`cut -d"(" -f2 < syslog.log | cut -d")" -f1 | sort | uniq`

for user in $userList
do
    printf "%s, Error: %d, Info: %d\n" $user $(grep -cP "ERROR.*(\b$user\b)" syslog.log) $(grep -cP "INFO.*(\b$user\b)" syslog.log);
done
```
Output 1(c) di terminal:<br>
[![Output 1c](https://iili.io/qUvwNV.png)](https://iili.io/qUvwNV.png)

### Poin (d)
Semua informasi yang didapatkan pada poin (b) dituliskan ke dalam file error_message.csv dengan header Error,Count yang kemudian diikuti oleh daftar pesan error dan jumlah kemunculannya diurutkan berdasarkan jumlah kemunculan pesan error dari yang terbanyak.
Command:
- Pertama header Error,Count ditambahkan pada file error_message.csv.
- -o mengambil bagian dari baris yang sesuai dengan pola (Regex: ERROR diikuti spasi diikuti spasi dan apapun hingga akhir baris), lalu dari hasilnya diambil kembali bagian yang sesuai dengan pola (Regex: Kata di awal kalimat, diikuti maksimal 6 kata berikutnya).
- -E menandakan bahwa pola yang diberikan merupakan extended regex pattern.
- sort mengurutkan baris hasil cut secara ascending, dan uniq mengabaikan baris duplikat.
- Baris dicetak sesuai jumlah kemunculannya, lalu diurutkan berdasarkan jumlah kemunculannya secara descending, dan hasilnya ditambahkan ke akhir file error_message.csv.
```
echo "Error,Count" > error_message.csv
echo "$(grep -oE 'ERROR.*' syslog.log)" | grep -oE "([A-Z][a-z]+)\s(['A-Za-z]+\s){1,6}" | sort | uniq |
    while read -r line
    do
        errCount=`grep -c "$line" syslog.log`
        echo "$line,$errCount"
    done | sort -rt',' -nk2 >> error_message.csv
```

### Poin (e)
Semua informasi yang didapatkan pada poin (c) dituliskan ke dalam file user_statistic.csv dengan header Username,INFO,ERROR diurutkan berdasarkan username secara ascending.
Command:
- Pertama header Username,INFO,ERROR ditambahkan pada file user_statistic.csv.
- Iterasi menggunakan userList yang sudah diinisialisasi pada poin (c).
- grep menampilkan jumlah baris yang sesuai pola (Regex: INFO/ERROR diikuti apapun, dengan username yang sedang diiterasi di akhir baris)
- Baris yang dicetak menampilkan username dan jumlah error/info, lalu diurutkan berdasarkan username secara ascending, dan hasilnya ditambahkan ke akhir file user_statistic.csv.
```
echo "Username,INFO,ERROR" > user_statistic.csv
for user in $userList
do
    printf "%s,%d,%d\n" $user $(grep -cP "INFO.*(\b$user\b)" syslog.log) $(grep -cP "ERROR.*(\b$user\b)" syslog.log);
done | sort >> user_statistic.csv;
```
### Error/kendala selama pengerjaan
![image](https://user-images.githubusercontent.com/81247727/113501734-afd82600-9551-11eb-812c-8d524fe36e74.png)
- Kesalahan sintaks pada poin (c), sehingga ketika username 'ac' diiterasi, grep akan mengambil seluruh username yang mengandung (bukan yang tepat hanya berisi) 'ac'. Selain itu output dari error dan info terbalik, ex: username ahmed.miller harusnya memunculkan error sebanyak 4 dan info sebanyak 2.

## Soal 2
- `$LC_NUMERIC` diubah menjadi en_US.UTF-8 agar angka desimal yang dipisahkan dengan titik dalam file **Laporan-TokoShiSop.tsv** bisa langsung diproses tanpa perlu diubah menjadi koma terlebih dahulu.
- Field separator adalah tab ('\t') karena file dataset berekstensi .tsv (tab-separated values).
```
awk -F '\t'
```
- Variabel segMin dan regMin diinisialisasi pada blok BEGIN untuk digunakan pada poin (c) dan (d).
```
BEGIN{
	segMin=10000;
	regMin=1000000000000000;
}
```
- Sebelum memulai pengerjaan soal poin (a), data dalam masing-masing field/kolom tiap record/baris dimasukkan ke dalam variabel sesuai nama kolom untuk mempermudah pengerjaan. Karena baris pertama merupakan header maka pemrosesan data dimulai dari baris ke-2.
```
(NR>1) {
	rowID = $1;
	orderID = $2;
	orderDate = $3;
	shipDate = $4;
	shipMode = $5;
	customerID = $6;
	customerName = $7;
	segment = $8;
	country = $9;
	city = $10;
	state = $11;
	postalCode = $12;
	region = $13;
	productID = $14;
	category = $15;
	subcategory = $16;
	productName = $17;
	sales = $18;
	quantity = $19;
	discount = $20;
	profit = $21;
	...
```

### Poin (a)
Profit percentage dari setiap record dicari sesuai dengan rumus yang tersedia pada modul. Jika profit percentage pada record tersebut lebih dari (atau sama dengan, jika ada record yang lebih baru dengan profit percentage yang sama) profit percentage maksimal dari record-record sebelumnya (maxPP), maka profit percentage record tersebut dijadikan nilai maxPP baru. Nomor barisnya dimasukkan ke dalam variabel maxID.
```
profitPercentage = (profit/(sales-profit))*100;
if(profitPercentage >= maxPP){
  maxID = rowID;
  maxPP = profitPercentage;
}
```
Lalu pada blok END, output ditambahkan pada file hasil.txt dengan format berikut.
```
print "Transaksi terakhir dengan profit percentage terbesar yaitu " maxID" dengan persentase " maxPP "%.\n";
```

### Poin (b)
Jika nama kota adalah Albuquerque dan order date (dianggap string) diakhiri dengan angka '17' (menandakan tahun 2017), maka nama customer dijadikan sebagai indeks array dan diisi angka 1 (untuk mencegah entri duplikat).
```
if((city == "Albuquerque") && (substr(orderDate, length(orderDate)-1, 2) == "17")) {
		arr[customerName]=1;
}
```
Lalu pada blok END, output dicetak pada file hasil.txt dengan format berikut. Nama customer yang dijadikan indeks array dicetak menggunakan loop.
```
print "Daftar nama customer di Albuquerque pada tahun 2017 antara lain:"
for(i in arr) {
	print i;
}
```

### Poin (c)
Untuk setiap segment, nama segment dijadikan sebagai indeks array dan isinya diincrement setiap kali segment tersebut terbaca pada input.
```
segArr[segment]++;
```
Nama segment dengan transaksi paling sedikit dan jumlah transaksinya dimasukkan ke dalam variabel menggunakan loop.
```
for (j in segArr){
	# print segArr[j]
	if(segArr[j] < segMin){
		segMin = segArr[j];
		leastSeg = j;	
	}
}
```
Lalu pada blok END, output dicetak pada file hasil.txt dengan format berikut.
```
print "\nTipe segmen customer yang penjualannya paling sedikit adalah " leastSeg " dengan " segMin " transaksi."
```

### Poin (d)
Untuk setiap region, nama region dijadikan sebagai indeks array dan isinya ditambahkan dengan profit yang dibaca pada tiap baris input.
```
regArr[region] += profit;
```
Nama region dengan keuntungan/profit paling sedikit dan jumlah keuntungannya dimasukkan ke dalam variabel menggunakan loop.
```
for (k in regArr){
	# print regArr[k]
	if(regArr[k] < regMin){
		regMin = regArr[k];
		leastReg = k;	
	}
}
```
Lalu pada blok END, output dicetak pada file hasil.txt dengan format berikut. Total keuntungan ditampilkan dengan ketelitian 4 angka di belakang koma karena setelahnya hanya ada angka 0.
```
printf "\nWilayah bagian (region) yang memiliki total keuntungan (profit) yang paling sedikit adalah %s dengan total keuntungan %.4f\n", leastReg, regMin;
```

Berikut isi file **hasil.txt** setelah eksekusi script **soal2_generate_laporan_ihir_shisop.sh**.
```
Transaksi terakhir dengan profit percentage terbesar yaitu 9952 dengan persentase 100%.

Daftar nama customer di Albuquerque pada tahun 2017 antara lain:
Benjamin Farhat
David Wiener
Michelle Lonsdale
Susan Vittorini

Tipe segmen customer yang penjualannya paling sedikit adalah Home Office dengan 1783 transaksi.

Wilayah bagian (region) yang memiliki total keuntungan (profit) yang paling sedikit adalah Central dengan total keuntungan 39706.3625
```

## Soal 3
### Poin (a)
Total gambar yang diunduh adalah 23, berarti ada 23 iterasi dalam script. Jika nomor file <10 maka di depannya ditambahkan angka 0. Kemudian, gambar di-download dari `https://loremflickr.com/320/240/kitten` dengan nama file sesuai blok if, dan lognya disimpan dalam file Foto.log.
```
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
	...
```
Blok dibawah ini akan menyimpan setiap hasil string `awk '/https:\/\/loremflickr.com\/cache\/resized\// {print $3}'` dari file Foto.log ke array `awk_array`. Array tersebut akan dgunakan untuk membandingkan hasil setiap elemen array saat looping dengan array urutan terakhir. Dimulai dengan variabel `check_eq=1` sebagai flag. Lalu akan diiterasi mulai dari 0 sampai `$i-1`. Jika hasil string sama, maka print `"SAMA"` dan ubah value `check_eq` menjadi 0. Jika value `check_eq` sama dengan 0 maka hapus file yg terakhir didownload. Lalu variabel `fileNum` akan dimundurkan 1 agar penamaan file setelah ada yang dihapus tidak melompat. Jika hasil string berbeda, iterasi dilanjutkan dan hitungan nomor file dinaikkan untuk dibawa ke iterasi selanjutnya.

```
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
```

### Poin (b) - bash
Pertama-tama masuk ke dalam direktori tempat disimpannya script, dan eksekusi script soal3a.sh untuk mendownload gambar.
```
cd $(dirname $0)
bash ./soal3a.sh
```
Blok kode ini membuat folder yang namanya sesuai dengan tanggal dibuatnya folder tersebut.
```
folderName=$(date +"%d-%m-%Y")
mkdir "$folderName"
```
Lalu selanjutnya, semua file yang namanya diawali dengan "Koleksi_" yang telah di-download beserta Foto.log dipindahkan ke folder `$folderName`.
```
mv ./Koleksi_* "./$folderName/"
mv ./Foto.log "./$folderName/"
```

### Poin (b) - cron
File soal3b.sh dijalankan pada jam 20.00 pada tanggal 1 dan setiap 7 hari setelahnya, serta pada tanggal 2 dan setiap 4 hari setelahnya.
```
0 20 1-31/7,2-31/4 * * bash ~/soal-shift-sisop-modul-1-F12-2021/soal3/soal3b.sh
```

### Poin (c)
Pertama-tama masuk ke dalam direktori tempat disimpannya script. Berdasarkan `$yesterday` dan `$today` yang telah diinisialisasi, cek apakah folder Kucing dengan tanggal kemarin sudah ada. Jika ada, maka hari ini download foto kelinci. Jika tidak, maka hari ini download foto kucing.
```
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
```
Sama dengan poin (a), total gambar yang diunduh adalah 23, berarti ada 23 iterasi dalam script. Jika nomor file <10 maka di depannya ditambahkan angka 0. Kemudian, gambar di-download dari `https://loremflickr.com/320/240/` disambung dengan `$download` sesuai apa yang harus di-download hari ini (kitten/bunny), dengan nama file sesuai blok if, dan lognya disimpan dalam file Foto.log. Untuk setiap file yang tersimpan dari iterasi sebelum iterasi ini, dibandingkan dengan file yang di-download pada iterasi ini. Jika sama, maka perintah `cmp` akan mengeluarkan exit status 0, gambar yang di-download pada iterasi ini dihapus, hitungan nomor file dimundurkan 1, dan iterasi dihentikan. Jika file berbeda, iterasi dilanjutkan dan hitungan nomor file dinaikkan untuk dibawa ke iterasi selanjutnya.
```
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
	
	wget -O "$fileName" -a Foto.log https://loremflickr.com/320/240/$download
	
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
```
Buat folder dengan nama sesuai `$folderName` yang didefinisikan pada blok if, lalu pindahkan semua file Koleksi_* dan Foto.log ke dalam folder tersebut.
```
mkdir "$folderName"
mv ./Koleksi_* "./$folderName/"
mv ./Foto.log "./$folderName/"
```

### Poin (d)
Blok kode ini akan men-zip seluruh folder yang memiliki awalan Kucing dan Kelinci. Kemudian, hasil zip-nya akan diberi password berupa tanggal saat zip dibuat. `-emqr` adalah argumen pada perintah zip agar proses zip dilakukan secara encrypted, quiet (berjalan di latar belakang), recursive, lalu menghapus file aslinya.
```
cd $(dirname $0)
zip -emqr Koleksi.zip ./Kucing* ./Kelinci* -P `date +"%m%d%Y"`
```

### Poin (e)
Perintah di bawah akan menjadwalkan eksekusi script soal3d.sh untuk membuat file .zip dari folder koleksi foto yang ada setiap hari Senin-Jumat jam 07.00. 
```
0 7 * * 1-5 bash ~/soal-shift-sisop-modul-1-F12-2021/soal3/soal3d.sh
```
Lalu perintah selanjutnya akan mengekstrak file Koleksi.zip dengan command `unzip` setiap hari Senin-Jumat jam 18.00, dengan melakukan `cd` terlebih dahulu ke direktori di mana file ini disimpan. `-qP` menandakan proses akan berjalan di latar belakang dan file akan di-unzip dengan password sesuai tanggal saat unzip dilakukan. Setelah unzip selesai, file Koleksi.zip dihapus dengan command `rm`.
```
0 18 * * 1-5 cd $(dirname $0); unzip -qP `date +"%m%d%Y"` Koleksi.zip && rm Koleksi.zip
```
### Error/kendala selama pengerjaan
- Setelah revisi, baru diketahui bahwa untuk membandingkan kedua gambar harus menggunakan AWK, sehingga script poin (a) harus diperbaiki.

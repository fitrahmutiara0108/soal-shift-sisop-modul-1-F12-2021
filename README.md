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
```
grep -oE 'INFO\s.*|ERROR\s.*' syslog.log > logTest.txt
```

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

### Poin (c)
Menampilkan jumlah kemunculan log ERROR dan INFO untuk setiap user.
Command:
- cut memotong baris dari awal hingga ditemukan '(' sebagai delimiter, lalu hasilnya dipotong hingga ditemukan ')', menghasilkan string berupa username pengguna.
- -d menandakan delimiter/batas antar field pada baris.
- sort mengurutkan baris hasil cut secara ascending, dan uniq mengabaikan baris duplikat.
- grep menampilkan jumlah baris yang sesuai pola (Regex: INFO/ERROR diikuti apapun, dengan username yang sedang diiterasi di akhir baris)
- Baris yang dicetak menampilkan username dan jumlah error/info.
```
userList=`cut -d"(" -f2 < syslog.log | cut -d")" -f1 | sort | uniq`

for user in $userList
do
    printf "%s, Error: %d, Info: %d\n" $user $(grep -cP "INFO.*($user)" syslog.log) $(grep -cP "ERROR.*($user)" syslog.log);
done
```

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
    printf "%s,%d,%d\n" $user $(grep -cP "INFO.*($user)" syslog.log) $(grep -cP "ERROR.*($user)" syslog.log);
done | sort >> user_statistic.csv;
```

## Soal 2
- Sebelum memulai pengerjaan soal poin (a), data dalam masing-masing kolom tiap baris dimasukkan ke dalam variabel sesuai nama kolom untuk mempermudah pengerjaan.
- `$LC_NUMERIC` diubah menjadi en_US.UTF-8 agar angka desimal yang dipisahkan dengan titik dalam file **Laporan-TokoShiSop.tsv** bisa langsung diproses tanpa perlu diubah menjadi koma terlebih dahulu.
-  Variabel segMin dan regMin diinisialisasi pada blok BEGIN untuk digunakan pada poin (c) dan (d).

### Poin (a)
Profit percentage dari setiap record dicari sesuai dengan rumus yang tersedia pada modul. Jika profit percentage pada record tersebut lebih dari (atau sama dengan, jika ada record yang lebih baru dengan profit percentage yang sama) profit percentage maksimal dari record-record sebelumnya (maxPP), maka profit percentage record tersebut dijadikan nilai maxPP baru. Nomor barisnya dimasukkan ke dalam variabel maxID.
```
profitPercentage = (profit/(sales-profit))*100;
if(profitPercentage >= maxPP){
  maxID = rowID;
  maxPP = profitPercentage;
}
```
Lalu output ditambahkan pada file hasil.txt dengan format berikut.
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
Lalu output dicetak pada file hasil.txt dengan format berikut. Nama customer yang dijadikan indeks array dicetak menggunakan loop.
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
Lalu output dicetak pada file hasil.txt dengan format berikut.
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
Lalu output dicetak pada file hasil.txt dengan format berikut. Total keuntungan ditampilkan dengan ketelitian 4 angka di belakang koma karena setelahnya hanya ada angka 0.
```
printf "\nWilayah bagian (region) yang memiliki total keuntungan (profit) yang paling sedikit adalah %s dengan total keuntungan %.4f\n", leastReg, regMin;
```

# Soal 3
## Poin (b) bash
```
folderName=$(date +"%d-%m-%Y")
mkdir "$folderName"
```
Pada blok kode ini, kita membuat folder yang nama folder tersebut merupakan tanggal create nya

```
mv ./Koleksi_* "./$folderName/"
mv ./Foto.log "./$folderName/"
```
Lalu selanjut nya, semua file Koleksi yang telah di download beserta ```Foto.log``` di pindahkan ke folder ```$foldername```

## Poin (b) cron

## Poin (d)

```
cd $(dirname $0)
zip -emqr Koleksi.zip ./Kucing* ./Kelinci* -P `date +"%m%d%Y"`
```
Blok kode ini akan men-zip seluruh Folder yang memiliki awalan ```Kucing``` dan ```Kelinci```. Lalu hasil zip nya akan diberi password berupa tanggal saat ini. ```-emqr``` adalah argumen pada perintah zip agar proses zip dilakukan secara encrypted, quiet, recursive, lalu menghapus file asli nya.

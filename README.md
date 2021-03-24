# Soal Shift Modul 1 Sisop 2021 (Kelompok F12)
#### Nama anggota kelompok:
- Farhan Arifandi (05111940000061)
- Fitrah Mutiara (05111940000126)
- M. Iqbal Abdi (05111940000151)

## Soal 1

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

## Soal 3

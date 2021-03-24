#!/bin/bash

awk -F '\t' '
BEGIN{
	segMin=10000;
	regMin=1000000000000000;
}

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
	
	profitPercentage = (profit/(sales-profit))*100;
	if(profitPercentage >= maxPP){
		maxID = rowID;
	 	maxPP = profitPercentage;
	}
	
	if((city == "Albuquerque") && (substr(orderDate, length(orderDate)-1, 2) == "17")) {
		arr[customerName]=1;
	}
	
	segArr[segment]++;
	regArr[region] += profit;
}

END {
	print "Transaksi terakhir dengan profit percentage terbesar yaitu " maxID" dengan persentase " maxPP "%.\n";
	
	print "Daftar nama customer di Albuquerque pada tahun 2017 antara lain:"
	for(i in arr) {
		print i;
	}
	
	for (j in segArr){
	# print segArr[j]
		if(segArr[j] < segMin){
			segMin = segArr[j];
			leastSeg = j;	
		}
	}
	
	print "\nTipe segmen customer yang penjualannya paling sedikit adalah " leastSeg " dengan " segMin " transaksi."
	
	for (k in regArr){
	# print regArr[k]
		if(regArr[k] < regMin){
			regMin = regArr[k];
			leastReg = k;	
		}
	}
	
	printf "\nWilayah bagian (region) yang memiliki total keuntungan (profit) yang paling sedikit adalah %s dengan total keuntungan %.4f\n", leastReg, regMin;

}' Laporan-TokoShiSop.tsv > hasil.txt

#include <stdlib.h>
#include <stdio.h>

/*
Täisarvudest koosneva jada sorteerimismeetodid.
*/

/*
Kahe elemendi omavahel vahetamine. Mõned
sorteerimisalgoritmid kasutavad seda.
*/
int swap(int *a, int *b) {
	int t=*a; *a=*b; *b=t;
	return 0;
}

/*
Kiirmeetod. (n log n)
Baastöö, lk. 4
*/
int quicksort(int *jada, int l, int r) {
	int start, end, mid, tmp, i;
	
	start=l;
	end=r;
	i=l+r;
	mid=jada[(i-i%2)/2];
	
	while (start<end) {
		while (start<r && jada[start]<mid) start++;
		while (end>l && jada[end]>mid) end--;
		if (start<end) {
			tmp=jada[end];
			jada[end]=jada[start];
			jada[start]=tmp;
			end--;
		}
		start++;
	}
	
	if (l<end) quicksort(jada, l, end);
	if ((end+1)<r) quicksort(jada, end+1, r);
	return 1;
}

/*
Mullimeetod. (n^2)
Baastöö, lk. 10
*/
int bubblesort(int *jada, int n) {
	int i,j,tmp;
	
	for (i=0; i<n-1; i++) {
		for (j=0; j<n-i-1; j++) {
			if (jada[j+1]<jada[j]) { //Naabrite võrdlemine
				tmp=jada[j]; //Teeme elementide vahetuse
				jada[j]=jada[j+1];
				jada[j+1]=tmp;
			}
		}
	}
	return 1;
}


/*
Pistemeetod. (n^2)
"Numerical Recipes in C", lk. 330
*/
int pistesort(int *jada, int n) {
	int i, j;
	int a;
	
	for (j=1; j<n; j++) { //Tsükkel üle elementide
		a=jada[j];
		i=j-1;
		
		//Elemendile koha leidmine
		
		while (i>=0 && jada[i]>a) {
			jada[i+1]=jada[i];
			i--;
		}
		jada[i+1]=a;
	}
	return 1;	
}

/*
Shell'i meetod (n^(3/2))
"Numerical Recipes in C", lk. 332
*/
int shellsort(int *jada, int n) {
	int i,j,inc,v;
	inc=0;
	
	//Algsammu arvutamine
	
	do {
		inc*=3;
		inc++;
	} while (inc<=n);
	
	do { 
		//Tsükkel üle erinevate sammude
		
		inc/=3;
		for (i=inc; i<n; i++) {
		
			//Pistemeetodi välimine tsükkel
			
			v=jada[i];
			j=i;
			while (jada[j-inc]>v) {
			
				//Pistemeetodi sisemine tsükkel
				
				jada[j]=jada[j-inc];
				j-=inc;
				if (j<inc) break;			
			}
			jada[j]=v;
		}
	} while (inc>0);
	return 1;
}

/*
Ühildusmeetod. (n log n)
"Algoritmid ja andmestruktuurid", lk. 67
Modifitseeritud ühildusega
*/
int mergesort(int *jada, int *abi, int i, int j) {

	int k;
	int t;
	
	if (i==j) return;
	
	k=(i+j)/2;
	
	//Sorteerime jadapooled eraldi
	
	mergesort(jada, abi, i, k);
	mergesort(jada, abi, k+1, j);    
	
	//Ühildame jadad
	
	merge(jada, abi, i, k, j);
	return 1;	
}

/*
Ühildusmeetodi abiprotseduur.
*/
int merge(int *jada, int *abi, int lo, int m, int hi) {
	int i=lo, j=hi, k=lo;

	//Esimese poole kopeerimine abijadasse
	while (i<=m) abi[k++]=jada[i++];

	//Teise poole kopeerimine abijadasse tagurpidises
	//järjekorras
	while (j>m) abi[k++]=jada[j--];

	i=lo; j=hi; k=lo;
    
	//Järjest suurima elemendi võtmine ja tagasikopeerimine
	//originaaljadasse
	while (i<=j)
		if (abi[i]<=abi[j]) jada[k++]=abi[i++];
		else jada[k++]=abi[j--];
	return 1;
}

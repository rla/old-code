#include <stdlib.h>

/*
Täisarvudest koosneva jada unikaalsuse kontrollimise
funktsioonid.

Iga funktsioon:

Tagastab 1, kui jada on unikaalne, vastasel
korral tagastab 0-i;
*/

/*
Jada suurusega n unikaalsuse kontrollimine sorteerimist
kasutamata, paare võrreldes.
*/
int onUnikaalne1(int *jada, int n) {
	int i,j;
	
	for (i=0; i<n; i++)
		for (j=0; j<i; j++) if (jada[i]==jada[j]) return 0;
		
	return 1;	
}

/*
Jada suurusega n unikaalsuse kontrollimine, kasutades C
standardset kiirsordi meetodit qsort.
*/
int onUnikaalne2(int *jada, int n) {

	int i;

	//Võrdlusfunktsioon, vajalik C kiirsordi jaoks
	
	int compare(void *a, void *b) {
		return (*(int*)a - *(int*)b);
	}
	
	qsort(jada, n, sizeof(int), compare);
	
	//Otsime duplikaate
	
	for (i=0; i<n-1; i++) if (jada[i]==jada[i+1]) return 0;
	
	return 1;
	
}

/*
Unikaalsuse kontroll sorteerimisega, kasutades sorteerimiseks
pistemeetodit.
*/
int onUnikaalne3(int *jada, int n) {

	int i;

	//Sorteerime jada
	
	pistesort(jada, n);

	//Otsime duplikaate
	
	for (i=0; i<n-1; i++) if (jada[i]==jada[i+1]) return 0;

	return 1;

}

/*
Unikaalsuse kontroll sorteerimisega, kasutades sorteerimiseks
ühildusmeetodit.
*/
int onUnikaalne4(int *jada, int n) {

	int i;

	//Sorteerime jada
	
	int *abi=malloc(sizeof(int)*n);
	mergesort(jada, abi, 0, n);
	free(abi);

	//Otsime duplikaate
	
	for (i=0; i<n-1; i++) if (jada[i]==jada[i+1]) return 0;

	return 1;
	
}

/*
Unikaalsuse kontroll sorteerimisega, kasutades sorteerimiseks
Shell'i meetodit.
*/

int onUnikaalne5(int *jada, int n) {

	int i;

	//Sorteerime jada
	
	shellsort(jada, n);

	//Otsime duplikaate
	
	for (i=0; i<n-1; i++) if (jada[i]==jada[i+1]) return 0;

	return 1;
	
}

/*
Unikaalsuse kontroll sorteerimisega, kasutades sorteerimiseks
mullimeetodit.
*/
int onUnikaalne6(int *jada, int n) {
	int i;

	//Sorteerime jada
	
	bubblesort(jada, n);

	//Otsime duplikaate
	
	for (i=0; i<n-1; i++) if (jada[i]==jada[i+1]) return 0;

	return 1;	
}

/*
Unikaalsuse kontroll sorteerimisega, kasutades sorteerimiseks
tavalist kiirmeetodit.
*/
int onUnikaalne7(int *jada, int n) {
	int i;

	//Sorteerime jada
	
	quicksort(jada, 0, n);

	//Otsime duplikaate
	
	for (i=0; i<n-1; i++) if (jada[i]==jada[i+1]) return 0;

	return 1;	
}

/*
Unikaalsuse kontroll sorteerimisega, kasutades sorteerimiseks
pistemeetodit ja kontrollides võrdsete elementide olemasolu
sorteerimise ajal.
*/
int onUnikaalne8(int *jada, int n) {
	int i, j;
	int a;
	
	for (j=1; j<n; j++) { //Tsükkel üle elementide
		a=jada[j];
		i=j-1;
		
		//Elemendile koha leidmine
		
		while (i>=0 && jada[i]>=a) {
			if (jada[i]==a) return 0; //Võrdsuse kontroll
			jada[i+1]=jada[i];
			i--;
		}
		jada[i+1]=a;
	}
	return 1;	
}

/*
Unikaalsuse kontroll sorteerimisega, kasutades sorteerimiseks
mullimeetodit ja kontrollides võrdsete elementide olemasolu
sorteerimise ajal.
*/
int onUnikaalne9(int *jada, int n) {
	int i,j,tmp;
	for (i=0; i<n-1; i++) {
		for (j=0; j<n-i-1; j++) {
			if (jada[j+1]<jada[j]) { //Naabrite võrdlemine
				tmp=jada[j]; //Teeme elementide vahetuse
				jada[j]=jada[j+1];
				jada[j+1]=tmp;
			} else if (jada[j+1]==jada[j]) { //Võrdsuse kontroll
				return 0;
			}
		}
	}
	return 1;	
}

/*
Unikaalsuse kontroll sorteerimisega, kasutades sorteerimiseks
Shell'i meetodit ja kontrollides võrdsete elementide olemasolu
sorteerimise ajal.
*/
int onUnikaalne10(int *jada, int n) {
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
			if (jada[j-inc]==v && !(inc==0)) return 0; //Võrdsuse kontroll
			jada[j]=v;
		}
	} while (inc>0);
	return 1;	
}

/*
Unikaalsuse kontroll sorteerimisega, kasutades sorteerimiseks
kiirmeetodit ja kontrollides võrdsete elementide olemasolu
sorteerimise ajal.
*/
int onUnikaalne11(int *jada, int n) {

	int u_quicksort(int *jada, int beg, int end) {
		int piv;
		int l,r;
		
		if (end>beg+1) {
			piv=jada[beg];
			l=beg+1;
			r=end;
			
			while (l<r) {
				if (jada[l] <= piv) {
					if (jada[l]==piv) return 0;
					l++;
				}
				else swap(&jada[l], &jada[--r]);
			}
			
     			swap(&jada[--l], &jada[beg]);
     			if (u_quicksort(jada, beg, l)==0) return 0;
     			if (u_quicksort(jada, r, end)==0) return 0;
		}
		return 1;
	}	
	return u_quicksort(jada, 0, n);
}

/*
Unikaalsuse kontroll sorteerimisega, kasutades sorteerimiseks
ühildusmeetodit ja kontrollides võrdsete elementide olemasolu
sorteerimise ajal.
*/
int onUnikaalne12(int *jada, int n) {

	//Ühildamise ja sorteerimisprotseduuri kohta vaata sort.c.
	//Siin kergelt modifitseeritud, teostamaks unikaalsuse kontrolli
	//sorteerimise ajal.
	int u_merge(int *jada, int *abi, int lo, int m, int hi) {
		int i=lo, j=hi, k=lo;

		while (i<=m) abi[k++]=jada[i++];
		while (j>m) abi[k++]=jada[j--];

		i=lo; j=hi; k=lo;

		while (i<=j)
			if (abi[i]<=abi[j]) {
				if (abi[i]==abi[j] && i!=j) return 0; //Võrdsete kontroll
				jada[k++]=abi[i++];
			} else jada[k++]=abi[j--];
			
		return 1;	
	}
	int u_mergesort(int *jada, int *abi, int i, int j) {

		int k;
		int t;
	
		if (i==j) return 1;
		k=(i+j)/2;
	
		//Kui juba ühes rekursioonipuu harus on
		//avastatud sarnased elemendid, lõpetame töö,
		//tagastades 0
		
		if (u_mergesort(jada, abi, i, k)==0) return 0;
		if (u_mergesort(jada, abi, k+1, j)==0) return 0;
	
		return u_merge(jada, abi, i, k, j);
	}
	
	int *abi=malloc(sizeof(int)*n);
	int ret=u_mergesort(jada, abi, 0, n);
	free(abi);
	return ret;
}

/*
Lineaarse keerukusega meetod (halvimal juhul).
Luuakse kontrollmassiiv (elementideks 0'd), mille indeksiteks on originaaljada
elemendid. Kui element on esinenud, kirjutatakse kontrollmassiivi
vastvale kohale 1, kui seal on juba 1, siis lõpetatakse töö
järeldusega, et jada pole unikaalne.
min - originaaljada minimaalne element
max - originaaljada maksimaalne element
*/
int onUnikaalne13(int *jada, int n, int min, int max) {
	int m=max-min;
	int *kontroll=malloc(m*sizeof(int));
	int i;
	for (i=0; i<m; i++) kontroll[i]=0; //Väärtustame kontrollmassiivi nullidega
	for (i=0; i<n; i++) {
		if (kontroll[jada[i]-min]==1) return 0;
		kontroll[jada[i]-min]=1;
	}
	free(kontroll);
	return 1;
}

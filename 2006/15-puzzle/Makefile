15: main.o laud.o kaik.o puu.o kaigud.o lahendaja.o
	gcc laud.o kaik.o puu.o kaigud.o lahendaja.o main.o -o 15
main.o:
	gcc -O2 -Wall -c -o main.o main.c
laud.o:
	gcc -O2 -Wall -c -o laud.o laud.c
kaik.o:
	gcc -O2 -Wall -c -o kaik.o kaik.c
puu.o:
	gcc -O2 -Wall -c -o puu.o puu.c
kaigud.o:
	gcc -O2 -Wall -c -o kaigud.o kaigud.c
lahendaja.o:
	gcc -O2 -Wall -c -o lahendaja.o lahendaja.c
clean:
	rm -f ./*.o
	rm -f ./*~
	rm -f ./15
	rm -f ./*.txt

lihtne:
	./15 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16

raske:
	./15 16 1 4 8 2 14 10 11 5 3 6 15 9 13 12 7

rebuild:
	make clean && make

test:
	./15 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 a > 0.txt
	./15 1 2 3 4 5 6 7 8 9 14 10 11 13 16 15 12 a > 5.txt
	./15 1 2 16 4 6 14 3 8 5 10 7 11 9 13 15 12 a > 10.txt
	./15 2 1 4 8 14 3 11 15 5 6 10 7 9 13 12 16 a > 25.txt
	./15 16 1 4 8 2 14 10 11 5 3 6 15 9 13 12 7 a > 40.txt
	./15 16 14 10 1 5 15 4 11 3 6 2 13 9 12 7 8 a > 50.txt
	./15 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 a > 100.txt
mittelahenduv:
	./15 2 1 12 4 10 14 6 11 9 3 13 7 16 15 8 5
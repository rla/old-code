
all: fnum.so

fnum.so: nested.f90
	f2py -c -m fnum $^

clean:
	rm -f *.so
	rm -f *.mod

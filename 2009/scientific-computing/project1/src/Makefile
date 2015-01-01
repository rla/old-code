
all: fnum.so

fnum.so: stationary.f90 nested.f90
	f2py -DF2PY_REPORT_ON_ARRAY_COPY -c -m fnum $^

clean:
	rm -f `find -iname '*.pyc'`
	rm -f *.so
	rm -f *.mod
	rm -f *.png
	rm -f movie.avi

doc:
	epydoc -v --parse-only --no-sourcecode `find -iname '*.py'`

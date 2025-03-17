test: test_tls.so
	SST_LIB_PATH=/home/vscode/sst-elements/install/lib/sst-elements-library:. \
	sst test_tls.py 

test_tls.o: test_tls.cc
	hg++ -c test_tls.cc

test_tls.so: test_tls.o
	hg++ test_tls.o -o test_tls.so

clean:
	rm -rf *.o *.so

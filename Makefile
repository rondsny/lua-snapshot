.PHONY : all linux mingw

all : linux

linux :
	gcc -g -Wall -fPIC --shared -o snapshot.so snapshot.c

mingw : 
	gcc -g -Wall --shared -o snapshot.dll snapshot.c -I/usr/local/include -L/usr/local/bin -llua53

mingw51 :
	gcc -g -Wall --shared -o snapshot.dll snapshot.c -I/usr/local/include -L/usr/local/bin -llua51

macosx :
	gcc -g -Wall --shared -undefined dynamic_lookup -I/Users/zixun/codes/lua/lua-5.3.4/src -o snapshot.so snapshot.c

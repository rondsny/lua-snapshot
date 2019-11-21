.PHONY : all linux mingw

all : macosx

linux :
	gcc -g -DDUMP_STRING -Wall -fPIC --shared -o snapshot.so snapshot.c

mingw : 
	gcc -g -Wall --shared -o snapshot.dll snapshot.c -I/usr/local/include -L/usr/local/bin -llua53

mingw51 :
	gcc -g -Wall --shared -o snapshot.dll snapshot.c -I/usr/local/include -L/usr/local/bin -llua51

macosx :
	gcc -g -DDUMP_STRING -Wall --shared -undefined dynamic_lookup -I/Users/zixun/codes/lua/lua-5.4.2/src -o snapshot.so snapshot.c
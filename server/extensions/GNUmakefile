all: wolfzilla.sqlext.so

wolfzilla.sqlext.so: wolfzilla_ext.c
	gcc -shared -fPIC -Isqlite3 -o wolfzilla.sqlext.so wolfzilla_ext.c 

clean:
	-rm -f wolfzilla.sqlext.so

test: all
	-LD_LIBRARY_PATH=. sqlite3 -batch < test.sql
	

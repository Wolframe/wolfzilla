#include <sqlite3ext.h>

#include <stdlib.h>
#include <limits.h>
#include <math.h>
#include <errno.h>
#include <string.h>

#define UNUSED_PARAMETER(x) (void)(x)

SQLITE_EXTENSION_INIT1

static void instrFunc(
  sqlite3_context *context,
  int argc,
  sqlite3_value **argv
){
  const unsigned char *zHaystack;
  const unsigned char *zNeedle;
  int nHaystack;
  int nNeedle;
  int typeHaystack, typeNeedle;
  int N = 1;
  int isText;

  UNUSED_PARAMETER(argc);
  typeHaystack = sqlite3_value_type(argv[0]);
  typeNeedle = sqlite3_value_type(argv[1]);
  if( typeHaystack==SQLITE_NULL || typeNeedle==SQLITE_NULL ) return;
  nHaystack = sqlite3_value_bytes(argv[0]);
  nNeedle = sqlite3_value_bytes(argv[1]);
  if( typeHaystack==SQLITE_BLOB && typeNeedle==SQLITE_BLOB ){
    zHaystack = sqlite3_value_blob(argv[0]);
    zNeedle = sqlite3_value_blob(argv[1]);
    isText = 0;
  }else{
    zHaystack = sqlite3_value_text(argv[0]);
    zNeedle = sqlite3_value_text(argv[1]);
    isText = 1;
  }
  while( nNeedle<=nHaystack && memcmp(zHaystack, zNeedle, nNeedle)!=0 ){
    N++;
    do{
      nHaystack--;
      zHaystack++;
    }while( isText && (zHaystack[0]&0xc0)==0x80 );
  }
  if( nNeedle>nHaystack ) N = 0;
  sqlite3_result_int(context, N);
}

int sqlite3_extension_init( sqlite3 *db, char **errmsg, const sqlite3_api_routines *api )
{
  SQLITE_EXTENSION_INIT2( api )
  sqlite3_create_function( db, "instr", 2, SQLITE_ANY, 0, instrFunc, 0, 0);
  return 0;
}

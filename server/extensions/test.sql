.load wolfzilla.sqlext
select substr( coalesce( "WOLFRAME-11", '' ), 1, instr( coalesce( "WOLFRAME-11", '' ), '-' ) - 1 );
select substr( coalesce( "WOLFRAME-11", '' ), instr( coalesce( "WOLFRAME-11", '' ), '-' ) + 1 );
.quit

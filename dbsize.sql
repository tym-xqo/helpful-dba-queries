select datname
     , pg_size_pretty(pg_database_size(datname)) db_size
  from pg_database
 order by db_size;
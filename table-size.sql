with rtsize as ( 
    select table_schema
         , table_name
         , pg_relation_size( quote_ident(table_schema) || '.' || quote_ident( table_name ) ) as size
         , pg_total_relation_size( quote_ident( table_schema ) || '.' || quote_ident( table_name ) ) as total_size  
      from information_schema.tables 
     where table_type = 'BASE TABLE' 
       and table_schema not in ('information_schema', 'pg_catalog') 
     order by pg_relation_size( quote_ident( table_schema ) || '.' || quote_ident( table_name ) ) desc, table_schema, table_name
    )
select table_schema
     , table_name
     , pg_size_pretty(size) as size
     , pg_size_pretty(total_size) as total_size 
  from rtsize x 
 order by --x.size desc
       --,
       x.total_size desc
       , table_schema
       , table_name;

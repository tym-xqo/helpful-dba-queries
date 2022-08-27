select s.schemaname as schema
     , s.relname as tbl
     , s.indexrelname as idx 
     , s.idx_scan as scans 
     , pg_size_pretty(pg_relation_size(s.relid)) as table_size
     , pg_size_pretty(pg_relation_size(s.indexrelid)) as index_size 
  from pg_stat_user_indexes s
  join pg_index i
    on i.indexrelid=s.indexrelid
  left join pg_constraint c
    on i.indrelid=c.conrelid
   and array_to_string(i.indkey, ' ') = array_to_string(c.conkey, ' ')
 where i.indisunique is false
   and pg_relation_size(s.relid) > 1000000
   and s.idx_scan < 100000
   and c.confrelid is null
 order by s.idx_scan asc
        , pg_relation_size(s.relid) desc ;

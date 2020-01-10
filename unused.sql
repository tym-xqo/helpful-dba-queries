select schemaname || '.' || relname as table
     , indexrelname as index
     , pg_size_pretty(pg_relation_size(i.indexrelid)) as index_size
     , idx_scan as index_scans
  from pg_stat_user_indexes ui
  join pg_index i
    on ui.indexrelid = i.indexrelid
 where not indisunique
   and idx_scan < 50
   and pg_relation_size(relid) > 5 * 8192
 order by pg_relation_size(i.indexrelid) / nullif(idx_scan, 0) desc NULLS first
     , pg_relation_size(i.indexrelid) desc;
;
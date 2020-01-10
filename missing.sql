select relname
     , seq_scan-idx_scan as too_much_seq
     , case when seq_scan-idx_scan > 0 then 'Missing Index?'
            else 'OK'
             end
     , pg_relation_size(relname::regclass) as rel_size
     , seq_scan
     , idx_scan
  from pg_stat_all_tables
 where schemaname='public'
   and pg_relation_size(relname::regclass) > 80000
 order by too_much_seq desc
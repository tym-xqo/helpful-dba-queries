select 'index hit rate' as name
     , (sum(idx_blks_hit)) / sum(idx_blks_hit + idx_blks_read) as ratio
  from pg_statio_user_indexes
union all select 'cache hit rate' as name
     , sum(heap_blks_hit) / (sum(heap_blks_hit) + sum(heap_blks_read)) as ratio
  from pg_statio_user_tables;
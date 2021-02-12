select relname
     , n_dead_tup
     , n_live_tup
     , n_dead_tup/nullif(n_live_tup::float,0) * 100 as pct_dead
     , last_autovacuum
     , last_vacuum
     , last_autoanalyze
     , last_analyze
  from pg_stat_user_tables
 where schemaname= 'public'
 order by 4 desc nulls last;
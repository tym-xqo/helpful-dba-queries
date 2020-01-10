select usename
     , state
     , count(*)
  from pg_stat_activity
 group by usename, state
 order by usename, state;
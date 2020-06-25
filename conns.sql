select usename
     , state
     , count(*)
     , max(age(now(), query_start)) max_query_age
  from pg_stat_activity
 group by usename, state
 order by usename, state;

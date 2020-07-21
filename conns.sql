select usename
     , state
     , count(*)
     , max(age(now(), query_start)) max_query_age
  from pg_stat_activity
 group by usename, state
 union all
 select 'total'
      , 'total'
      , count(*)
      , max(age(now(), query_start))
  from pg_stat_activity
 order by state, usename nulls first;

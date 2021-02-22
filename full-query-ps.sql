select pid
     , age(now(), xact_start) as xact_age
     , age(now(), query_start) as query_age
     , usename
     , application_name
     , query
     , state
  from pg_stat_activity
  -- where application_name='psql'
 where state != 'idle'
   and backend_type = 'client backend'
   and pid != pg_backend_pid()
 order by xact_start;

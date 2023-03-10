select pid
     , age(now(), xact_start) as xact_age
     , age(now(), query_start) as query_age
     , datname
     , usename
     , application_name
     , left(query, 25) || '..' || right(query, 25)  as query_snippet
     , wait_event_type
     , wait_event
     , state
  from pg_stat_activity
 where state != 'idle'
   and backend_type = 'client backend'
   and pid != pg_backend_pid()
  --  and usename in ('boost_reporting', 'boost_etl_user')
 order by xact_start;

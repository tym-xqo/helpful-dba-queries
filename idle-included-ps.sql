select pid
     , age(now(), xact_start) as xact_age
     , age(now(), query_start) as query_age
     , datname
     , usename
     , application_name
     , left(query, 40) as query_snippet
     , wait_event_type
     , wait_event
     , state
  from pg_stat_activity
 where --backend_type in ('client backend', 'background worker')
   --and 
   pid != pg_backend_pid()
 order by query_start nulls last

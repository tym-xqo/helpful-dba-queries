select pid
     , leader_pid
     , age(now(), xact_start) as xact_age
     , age(now(), query_start) as query_age
     , datname
     , usename
     , application_name
     , left(query, 25) || '..' || right(query, 25) as query_snippet
--,query
     , wait_event_type
     , wait_event
     , state
  from pg_stat_activity
-- exclude idle pids; use idle-included-ps.sql to see those 
 where state != 'idle'
-- inclue processes from clients only; we don't want server background processes in results
   and backend_type = 'client backend'
-- exclude this query from result
   and pid != pg_backend_pid()
 order by xact_start nulls last;

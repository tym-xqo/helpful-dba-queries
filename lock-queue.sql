with b as (
    select pid as blocked_pid
         , unnest(pg_blocking_pids(pid)) as blocking_pid
      from pg_locks
     where not granted
)
select b.blocked_pid
     , b.blocking_pid
     , left(a.query, 40) as blocked_query
     , left(c.query, 40) as blocking_query
     , c.query_start as blocking_start
     , c.state as blocking_state
  from b
  join pg_stat_activity a
    on b.blocked_pid = a.pid
  join pg_stat_activity c
    on b.blocking_pid = c.pid 
 order by c.query_start;
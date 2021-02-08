\c dba_metrics
show benchprep.hostname;

select 'checks failing: ' || count(*)::text fail_summary
  from perf_metric
 where status = 'failure'
   and stamp >= now() - interval'1min';

with current as (select max(pm.stamp) as stamp 
                      , pm.name
                  from perf_metric pm 
                 where stamp >= now() - interval'1min'
                 group by pm.name)
select stamp
     , name
     , status
  from perf_metric
  join current using (stamp, name) 
 order by status, name;

 select slot_name
     , "database"
     , pg_size_pretty(pg_wal_lsn_diff(pg_current_wal_lsn(), restart_lsn)) as restart_lag
     , pg_size_pretty(pg_wal_lsn_diff(pg_current_wal_lsn(), confirmed_flush_lsn)) as flush_lag
  from pg_replication_slots;

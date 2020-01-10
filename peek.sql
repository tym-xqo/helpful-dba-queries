\c dba_metrics
show benchprep.hostname;

select 'checks failing: ' || count(*)::text fail_summary
  from current_status 
 where status = 'failure';

select stamp
     , name
     , status
  from current_status 
 order by status, name;

 select slot_name
     , "database"
     , pg_size_pretty(pg_wal_lsn_diff(pg_current_wal_lsn(), restart_lsn)) as restart_lag
     , pg_size_pretty(pg_wal_lsn_diff(pg_current_wal_lsn(), confirmed_flush_lsn)) as flush_lag
  from pg_replication_slots;

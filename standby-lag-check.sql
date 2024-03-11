select slot_name
     , "database"
     , pg_size_pretty(pg_wal_lsn_diff(pg_last_wal_replay_lsn(), restart_lsn)) as restart_lag
     , pg_size_pretty(pg_wal_lsn_diff(pg_last_wal_replay_lsn(), confirmed_flush_lsn)) as flush_lag
  from pg_replication_slots;

select max(age(now(), xact_start)) as long_xact 
  from pg_stat_activity
;


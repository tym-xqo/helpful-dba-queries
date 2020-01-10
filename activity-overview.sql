select 
       datname
     , query_start
     , xact_start
     , pid
     , usename
     , application_name
     , client_addr
     , client_hostname
     , client_port
     , query
     , state
  from pg_stat_activity
  where backend_type = 'client backend'
    and pid != pg_backend_pid()
  order by query_start;
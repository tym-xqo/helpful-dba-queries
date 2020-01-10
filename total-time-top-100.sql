select (total_time / 1000 / 60) as total_minutes 
     , calls 
     , (total_time/calls) as average_time 
     , query
  from pg_stat_statements
 order by 1 desc
 limit 100;
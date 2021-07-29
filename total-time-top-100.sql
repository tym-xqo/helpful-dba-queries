select (total_time / 1000 / 60) as total_minutes 
     , calls 
     , mean_time
     , stddev_time
     , max_time
     , min_time
     , left(query, 180) as query_snip
  from pg_stat_statements
 order by 2 desc
 limit 100;

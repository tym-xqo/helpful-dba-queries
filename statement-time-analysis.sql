select (total_time / 1000 / 60) as total_minutes 
     , calls 
     , mean_time
     , stddev_time
     , max_time
     , min_time
     , query
  from pg_stat_statements
 where rtrim(lower(substr(ltrim(query), 1, position(' ' IN query)))) = 'update'
 order by calls * stddev_time desc
 limit 10;

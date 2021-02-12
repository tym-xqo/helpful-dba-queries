select round(floor(max_time::numeric/60000) + floor((max_time::numeric/1000 % 60))/100, 2) as max_time_mt_ss
     , round(floor(mean_time::numeric/60000) + floor((mean_time::numeric/1000 % 60))/100, 2) as mean_time_mt_ss
     , min_time as min_time_ms
     , calls
     , left(query, 45) as query_snippet
     , queryid
     , total_time
  from pg_stat_statements
 order by max_time desc
 limit 10;

select sum(total_time)/sum(calls) as mean_query_time
     , sum(calls) as total_calls
     , to_char(avg(100.0 * shared_blks_hit /
               nullif(shared_blks_hit + shared_blks_read, 0)), 'FM999999999.00') AS hit_percent
     , rtrim(lower(substr(ltrim(regexp_replace(query, E'[\\n\\r]+', ' ', 'g' )), 1, position(' ' IN query))))  as sql_verb
  from pg_stat_statements
 where lower(query) != 'select $1'
   and query not like '%pg_stat_%'
   and userid in (select oid 
                    from pg_authid 
                   where rolname in (
                         'boost_reporting'
                       , 'wmxdbuser'
                  )
   )
  --  and calls > 
  --             --  (select avg(calls)
  --              (select percentile_cont(0.99) 
  --               within group(order by calls) 
  --                  from pg_stat_statements)
 group by rtrim(lower(substr(ltrim(regexp_replace(query, E'[\\n\\r]+', ' ', 'g' )), 1, position(' ' IN query))))
union
select sum(total_time)/sum(calls)
     , sum(calls)
     , to_char(avg(100.0 * shared_blks_hit /
               nullif(shared_blks_hit + shared_blks_read, 0)), 'FM999999999.00')
     , 'z_overall'
  from pg_stat_statements
 where lower(query) != 'select $1'
   and query not like '%pg_stat_%'
   and userid in (select oid 
                    from pg_authid 
                   where rolname in (
                         'boost_reporting'
                       , 'wmxdbuser'
                  )
   )
  --  and calls >  
  --               -- (select avg(calls)
  --               (select percentile_cont(0.99) 
  --                within group(order by calls) 
  --                  from pg_stat_statements)
order by sql_verb
;

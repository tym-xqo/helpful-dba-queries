with filtered_stat as (
  select *
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
)
select sum(total_time)/sum(calls) as mean_query_time
     , sum(calls) as total_calls
     , sum(calls)::float/(select sum(calls) from filtered_stat)*100 as call_pct
     , sum(total_time) as cumulative_time
     , sum(total_time)::float/(select sum(total_time) from filtered_stat)*100 as cumulative_time_pct
     , rtrim(lower(substr(ltrim(regexp_replace(query, E'[\\n\\r]+', ' ', 'g' )), 1, position(' ' IN query))))  as sql_verb
  from filtered_stat
 group by rtrim(lower(substr(ltrim(regexp_replace(query, E'[\\n\\r]+', ' ', 'g' )), 1, position(' ' IN query))))
order by sql_verb
;

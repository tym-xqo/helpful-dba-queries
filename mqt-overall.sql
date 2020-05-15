select sum(total_time)/sum(calls) as mean_query_time
  from pg_stat_statements
 where lower(query) != 'select 1'
   and rtrim(lower(substr(ltrim(query), 1, position(' ' IN query)))) in (
       'select'
     , 'with'
     , 'update'
     , 'insert'
     , 'delete'
   )
   and userid in (select oid 
                    from pg_authid 
                   where rolname in (
                         'boost_reporting'
                       , 'wmxdbuser'
                  )
   )
   and calls > 100
;


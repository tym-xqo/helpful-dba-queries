select tablename as table_name
     , ROUND(case when otta=0 then 0.0 else sml.relpages/otta::numeric end,1) as table_bloat
     , case when relpages < otta then '0'
            else pg_size_pretty((bs*(sml.relpages-otta)::bigint)::bigint)
             end as table_waste
     , iname as index_name
     , ROUND(case when iotta=0 or ipages=0 then 0.0 else ipages/iotta::numeric end,1) as index_bloat
     , case when ipages < iotta then '0'
            else pg_size_pretty((bs*(ipages-iotta))::bigint)
             end as index_waste
  from (
        select schemaname
             , tablename
             , cc.reltuples
             , cc.relpages
             , bs
             , CEIL((cc.reltuples*((datahdr+ma- (case when datahdr%ma=0 then ma else datahdr%ma end))+nullhdr2+4))/(bs-20::float)) as otta
             , COALESCE(c2.relname,'?') as iname
             , COALESCE(c2.reltuples,0) as ituples
             , COALESCE(c2.relpages,0) as ipages
             , COALESCE(CEIL((c2.reltuples*(datahdr-12))/(bs-20::float)),0) as iotta
          from (
                select ma
                     , bs
                     , schemaname
                     , tablename
                     , (datawidth+(hdr+ma-(case when hdr%ma=0 then ma else hdr%ma end)))::numeric as datahdr
                     , (maxfracsum*(nullhdr+ma-(case when nullhdr%ma=0 then ma else nullhdr%ma end))) as nullhdr2
                  from (
                        select schemaname
                             , tablename
                             , hdr
                             , ma
                             , bs
                             , SUM((1-null_frac)*avg_width) as datawidth
                             , MAX(null_frac) as maxfracsum
                             , hdr+(
                                select 1+count(*)/8
                                  from pg_stats s2
                                 where null_frac<>0
                                   and s2.schemaname = s.schemaname
                                   and s2.tablename = s.tablename
                               ) as nullhdr
                          from pg_stats s
                             , (
                                select (
                                        select current_setting('block_size')::numeric
                                       ) as bs
                                     , case when substring(v,12,3) in ('8.0','8.1','8.2') then 27
                                            else 23
                                             end as hdr
                                     , case when v ~ 'mingw32' then 8
                                            else 4
                                             end as ma
                                  from (
                                        select version() as v
                                       ) as foo
                               ) as constants
                         group by 1
                                , 2
                                , 3
                                , 4
                                , 5
                       ) as foo
               ) as rs
          join pg_class cc
            on cc.relname = rs.tablename
          join pg_namespace nn
            on cc.relnamespace = nn.oid
           and nn.nspname = rs.schemaname
           and nn.nspname <> 'information_schema'
          left join pg_index i
            on indrelid = cc.oid
          left join pg_class c2
            on c2.oid = i.indexrelid
       ) as sml
 order by case when relpages < otta then 0
               else bs*(sml.relpages-otta)::bigint
                end desc;
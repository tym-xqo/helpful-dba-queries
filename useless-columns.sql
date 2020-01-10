select nspname
     , relname
     , attname
     , typname
     , (stanullfrac * 100)::int as null_percent
     , case when stadistinct >= 0 then stadistinct
            else abs(stadistinct) * reltuples
             end as distinct
     , case 1
            when stakind1 then stavalues1
            when stakind2 then stavalues2
             end as
values
  from pg_class c
  join pg_namespace ns
    on (ns.oid = relnamespace)
  join pg_attribute
    on (c.oid = attrelid)
  join pg_type t
    on (t.oid = atttypid)
  join pg_statistic
    on (c.oid = starelid and staattnum = attnum)
 where nspname not like 'pg_%' and nspname != 'information_schema' and relkind = 'r'
   and not attisdropped
   and attstattarget != 0
   and reltuples >= 100
   and stadistinct between 0 and 1
 order by null_percent desc
        , nspname
        , relname
        , attname;
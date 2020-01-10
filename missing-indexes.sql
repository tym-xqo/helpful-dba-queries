select src_table
     , dst_table
     , fk_name
     , pg_size_pretty(s_size) as s_size
     , pg_size_pretty(d_size) as d_size
     , d
  from (
        select distinct
            on (1,2,3,4,5) textin(regclassout(c.conrelid)) as src_table
             , textin(regclassout(c.confrelid)) as dst_table
             , c.conname as fk_name
             , pg_relation_size(c.conrelid) as s_size
             , pg_relation_size(c.confrelid) as d_size
             , array_upper(di.indkey::int[], 1) + 1 - array_upper(c.conkey::int[], 1) as d
          from pg_constraint c
          left join pg_index di
            on di.indrelid = c.conrelid
           and array_to_string(di.indkey, ' ') ~ ('^' || array_to_string(c.conkey, ' ') || '(|$)')
          join pg_stat_user_tables st
            on st.relid = c.conrelid
         where c.contype = 'f'
         order by 1
                , 2
                , 3
                , 4
                , 5
                , 6 asc
       ) mfk
 where mfk.d is distinct
  from 0
   and mfk.s_size > 1000000
 order by mfk.s_size desc
        , mfk.d desc ;
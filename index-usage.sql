select relname
     , case idx_scan
            when 0   then 'Insufficient data'
            else (100 * idx_scan / (seq_scan + idx_scan))::text
             end percent_of_times_index_used
     , n_live_tup rows_in_table
  from pg_stat_user_tables
 order by n_live_tup desc;
 
 select *
  from (
        select stat.relname as table
             , stai.indexrelname as index
             , case stai.idx_scan
                    when 0        then 'Insufficient data'
                    else (100 * stai.idx_scan / (stat.seq_scan + stai.idx_scan))::text || '%'
                     end hit_rate
             , case stat.idx_scan
                    when 0        then 'Insufficient data'
                    else (100 * stat.idx_scan / (stat.seq_scan + stat.idx_scan))::text || '%'
                     end all_index_hit_rate
             , ARRAY(
                select pg_get_indexdef(idx.indexrelid, k + 1, true)
                  from generate_subscripts(idx.indkey, 1) as k
                 order by k
               ) as cols
             , stat.n_live_tup rows_in_table
          from pg_stat_user_indexes as stai
          join pg_stat_user_tables as stat
            on stai.relid = stat.relid
          join pg_index as idx
            on (idx.indexrelid = stai.indexrelid)
       ) as sub_inner
 order by rows_in_table desc
        , hit_rate asc;
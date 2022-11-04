prepare cancel_repeats (text) as
    -- fetch repeated queries matching query snippet pattern

    -- fetch minimum pid for each repeated query
    -- TODO: make this based on `query_start` and get pid for min of that
      with mq as (
    select min(pid) as min_pid
         , query 
      from timed_activity
     where query like $1
     group by query
    having count(*) > 1
    )
    -- =======
    -- Uncomment below (and comment out the other main `select`) to check for 
    -- repeated queries without cancelling
    -- =======
    -- select min_pid
    --      , t.pid
    --      , mq.query
    --      , t.usename
    --   from mq
    --   join timed_activity as t
    --  using (query)
    --  order by mq.query
    -- =======
    -- cancel all pids except the min one
    select pg_cancel_backend(t.pid)
      from mq
      join timed_activity t
     using (query)
     where t.pid != min_pid
    ;
-- pass the prepared statement a query snippet
-- it matches using `like`
execute cancel_repeats('%COPY (WITH scoped_users%');

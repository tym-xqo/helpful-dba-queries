prepare cancel_repeats (text) as
    -- fetch repeated queries matching query snippet pattern
    with q as (
    select query 
      from timed_activity
     where query like $1     
     group by query
    having count(*) > 1
    ),
    -- fetch minimum pid for each repeated query
    -- TODO: make this based on `query_start` and get pid for min of that
    mq as (
    select min(pid) as min_pid
         , q.query 
      from timed_activity
      join q using (query)
     group by q.query
    )
    -- =======
    -- Uncomment below (and comment out the other main `select`) to check for 
    -- repeated queries without cancelling
    -- =======
    -- select min_pid
    --      , t.pid
    --      , mq.query
    --   from mq
    --   join timed_activity t
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
execute cancel_repeats('SELECT MAX("activities"%');

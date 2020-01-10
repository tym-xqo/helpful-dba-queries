\c dba_metrics
show benchprep.hostname;
select 'checks failing: ' || count(*)::text fail_summary
  from current_status 
 where status = 'failure';
select stamp
     , name
     , status
  from current_status 
 order by status, name;
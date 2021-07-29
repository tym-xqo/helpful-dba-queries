\set QUIET 1
\timing off
set role postgres;

create temp table if not exists uptime (uptime text);
truncate table uptime;
copy uptime from program 'uptime';
\timing on
\unset QUIET
select * from uptime;
\set QUIET 1
\timing off
drop table uptime;
\timing on
\unset QUIET

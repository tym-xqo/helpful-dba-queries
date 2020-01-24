begin;
select now(), pg_stat_reset();
select now(), pg_stat_statements_reset();
commit;

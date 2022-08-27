select 'SELECT SETVAL(' || quote_literal(quote_ident(pgt.schemaname) || '.' || quote_ident(s.relname)) || ', COALESCE(MAX(' ||quote_ident(c.attname)|| '), 1) ) +10 FROM ' || quote_ident(pgt.schemaname)|| '.'||quote_ident(t.relname)|| ';'
  from pg_class as s
     , pg_depend as d
     , pg_class as t
     , pg_attribute as c
     , pg_tables as pgt
 where s.relkind = 'S'
   and s.oid = d.objid
   and d.refobjid = t.oid
   and d.refobjid = c.attrelid
   and d.refobjsubid = c.attnum
   and t.relname = pgt.tablename
 order by s.relname
;

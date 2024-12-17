# Helpful DBA queries

A modest collection of queries I find useful/helpful in day-to-day checking on things in the database, as a PostgreSQL database administrator. Like others, I used to keep many of them bound to variables in my `.psqlrc` file, but found that made the actual query contents somewhat obscure and difficult to modify.

## Usage

After cloning this repository, for convenience I recommend setting up a symbolic link to it in your `$HOME` directory with a very short name -- I call mine `q`. 

```
$ ln -s </$path/$to/>helpful-dba-queries ~/q
```

This makes it easy to quickly access and submit any of these files for execution in `psql` from anywhere, using the `\i or \include` meta-command like (for example):

```
=> \i ~/q/ps.sql
```

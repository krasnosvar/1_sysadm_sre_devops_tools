#https://stackoverflow.com/questions/53769011/executing-sqlite3-query-in-bash
#sqllite commands directly in bash
cmd1="sqlite3 calcdb.db"
cmd2="select * from results"
$cmd1 "$cmd2"

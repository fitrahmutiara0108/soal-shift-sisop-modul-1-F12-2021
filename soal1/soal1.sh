#!/bin/bash

# Poin (a)
grep -oE 'INFO\s.*|ERROR\s.*' syslog.log > logTest.txt

# Poin (b)
grep -oE "ERROR\s([A-Z])([a-z]+)(\s[a-zA-Z']+){1,6}" syslog.log;
printf "Total: %d\n" $(grep -c "ERROR" syslog.log);

# Poin (c)
userList=`cut -d"(" -f2 < syslog.log | cut -d")" -f1 | sort | uniq`

for user in $userList
do
    printf "%s, Error: %d, Info: %d\n" $user $(grep -cP "ERROR.*(\b$user\b)" syslog.log) $(grep -cP "INFO.*(\b$user\b)" syslog.log);
done

# Poin (d)
echo "Error,Count" > error_message.csv
echo "$(grep -oE 'ERROR.*' syslog.log)" | grep -oE "([A-Z][a-z]+)\s(['A-Za-z]+\s){1,6}" | sort | uniq |
    while read -r line
    do
        errCount=`grep -c "$line" syslog.log`
        echo "$line,$errCount"
    done | sort -rt',' -nk2 >> error_message.csv

# Poin (e)
echo "Username,INFO,ERROR" > user_statistic.csv
for user in $userList
do
    printf "%s,%d,%d\n" $user $(grep -cP "INFO.*($user)" syslog.log) $(grep -cP "ERROR.*($user)" syslog.log);
done | sort >> user_statistic.csv;

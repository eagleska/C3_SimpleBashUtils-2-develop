#!/bin/bash

SUCCESS=0
FAIL=0
COUNTER=0
DIFF_RES=""

declare -a tests=(
"s test_dir/test_grep/test_0_grep.txt VAR"
"for s21_grep.c ./s21_grep.h VAR"
"for s21_grep.c"
"-e for -e int s21_grep.c ./s21_grep.h VAR"
"-e while -e void -e qwer -e erty -e qwer -e erty -e qwer -e erty -e qwer -e erty -e qwer -e erty -e qwer -e erty -e qwer -e erty -e qwer -e erty -e qwer -e erty -e qwer -e erty -e qwer -e erty -e qwer -e erty s21_grep.c VAR" 
)

declare -a extra=(
"-n for test_dir/test_grep/test_1_grep.txt test_dir/test_grep/test_2_grep.txt"
"-n -e "^\\}" test_dir/test_grep/test_1_grep.txt"
"-c -e "/\a" test_dir/test_grep/test_1_grep.txt"
"-ce int test_dir/test_grep/test_1_grep.txt test_dir/test_grep/test_2_grep.txt"
"-e int test_dir/test_grep/test_1_grep.txt"
"-nivh = test_dir/test_grep/test_1_grep.txt test_dir/test_grep/test_2_grep.txt"
"-e"
"-ie INT test_dir/test_grep/test_5_grep.txt"
"-echar test_dir/test_grep/test_1_grep.txt test_dir/test_grep/test_2_grep.txt"
"-iv int test_dir/test_grep/test_5_grep.txt"
"-in int test_dir/test_grep/test_5_grep.txt"
"-v test_dir/test_grep/test_1_grep.txt -e ank"
"-l for test_dir/test_grep/test_1_grep.txt test_dir/test_grep/test_2_grep.txt"
"-e = -e out test_dir/test_grep/test_5_grep.txt"
"-ne ing -e as -e the -e not -e is test_dir/test_grep/test_6_grep.txt"
"-c -e . test_dir/test_grep/test_1_grep.txt -e '.'"
"-l for no_file.txt test_dir/test_grep/test_2_grep.txt"
)

testing()
{
    t=$(echo $@ | sed "s/VAR/$var/")
    ./s21_grep $t > test_s21_grep.log
    grep $t > test_sys_grep.log
    DIFF_RES="$(diff -s test_s21_grep.log test_sys_grep.log)"
    (( COUNTER++ ))
    if [ "$DIFF_RES" == "Files test_s21_grep.log and test_sys_grep.log are identical" ]
    then
      (( SUCCESS++ ))
      echo "\033[31m$FAIL\033[0m/\033[32m$SUCCESS\033[0m/$COUNTER \033[32msuccess\033[0m grep $t"
    else
      (( FAIL++ ))
      echo "\033[31m$FAIL\033[0m/\033[32m$SUCCESS\033[0m/$COUNTER \033[31mfail\033[0m grep $t"
    fi
    rm test_s21_grep.log test_sys_grep.log
}

# специфические тесты
for i in "${extra[@]}"
do
    var="-"
    testing $i
done

# 1 параметр
for var1 in v c l n h
do
    for i in "${tests[@]}"
    do
        var="-$var1"
        testing $i
    done
done

# 3 параметра
for var1 in v c l n h
do
    for var2 in v c l n h
    do
        for var3 in v c l n h
        do
            if [ $var1 != $var2 ] && [ $var2 != $var3 ] && [ $var1 != $var3 ]
            then
                for i in "${tests[@]}"
                do
                    var="-$var1 -$var2 -$var3"
                    testing $i
                done
            fi
        done
    done
done

# 2 сдвоенных параметра
for var1 in v c l n h
do
    for var2 in v c l n h
    do
        if [ $var1 != $var2 ]
        then
            for i in "${tests[@]}"
            do
                var="-$var1$var2"
                testing $i
            done
        fi
    done
done

# 3 строенных параметра
for var1 in v c l n h
do
    for var2 in v c l n h
    do
        for var3 in v c l n h
        do
            if [ $var1 != $var2 ] && [ $var2 != $var3 ] && [ $var1 != $var3 ]
            then
                for i in "${tests[@]}"
                do
                    var="-$var1$var2$var3"
                    testing $i
                done
            fi
        done
    done
done

echo "\033[31mFAIL: $FAIL\033[0m"
echo "\033[32mSUCCESS: $SUCCESS\033[0m"
echo "ALL: $COUNTER"

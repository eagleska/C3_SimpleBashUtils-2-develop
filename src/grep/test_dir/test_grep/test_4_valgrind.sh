#!/bin/bash
gcc src/grep/s21_grep.c -Wall -Wextra -Werror -o ./main -g
SUCCESS=0
FAIL=0
COUNTER=0
RES=""

declare -a tests=(
"s grep/test_dir/test_grep/test_0_grep.txt VAR"
"for grep/s21_grep.c ./s21_grep.h VAR"
"for grep/s21_grep.c VAR"
"for grep/s21_grep.c"
"-e dark grep/datasets/TheDreamQuestOfUnknownKadath"
"-e gods grep/datasets/TheOtherGods"
"-e for -e int grep/s21_grep.c ./s21_grep.h VAR"
"-e for -e int grep/s21_grep.c VAR"
"-e regex -e print grep/s21_grep.c VAR -f grep/test_dir/test_grep/test_ptrn_grep.txt"
"-e while -e void -e qwer -e erty -e qwer -e erty -e qwer -e erty -e qwer -e erty -e qwer -e erty -e qwer -e erty -e qwer -e erty -e qwer -e erty -e qwer -e erty -e qwer -e erty -e qwer -e erty -e qwer -e erty grep/s21_grep.c VAR -f grep/test_dir/test_grep/test_ptrn_grep.txt"
)

declare -a extra=(
"-n for grep/test_dir/test_grep/test_1_grep.txt grep/test_dir/test_grep/test_2_grep.txt"
"-n for grep/test_dir/test_grep/test_1_grep.txt"
"-n -e "^\\}" grep/test_dir/test_grep/test_1_grep.txt"
"-c -e "/\\" grep/test_dir/test_grep/test_1_grep.txt"
"-ce int grep/test_dir/test_grep/test_1_grep.txt grep/test_dir/test_grep/test_2_grep.txt"
"-e int grep/test_dir/test_grep/test_1_grep.txt"
"-nivh = grep/test_dir/test_grep/test_1_grep.txt grep/test_dir/test_grep/test_2_grep.txt"
"-e"
"-ie INT grep/test_dir/test_grep/test_5_grep.txt"
"-echar grep/test_dir/test_grep/test_1_grep.txt grep/test_dir/test_grep/test_2_grep.txt"
"-ne = -e out grep/test_dir/test_grep/test_5_grep.txt"
"-iv int grep/test_dir/test_grep/test_5_grep.txt"
"-in int grep/test_dir/test_grep/test_5_grep.txt"
"-v grep/test_dir/test_grep/test_1_grep.txt -e ank"
"-noe ) grep/test_dir/test_grep/test_5_grep.txt"
"-l for grep/test_dir/test_grep/test_1_grep.txt grep/test_dir/test_grep/test_2_grep.txt"
"-o -e int grep/test_dir/test_grep/test_4_grep.txt"
"-e = -e out grep/test_dir/test_grep/test_5_grep.txt"
"-noe ing -e as -e the -e not -e is grep/test_dir/test_grep/test_6_grep.txt"
"-e ing -e as -e the -e not -e is grep/test_dir/test_grep/test_6_grep.txt"
"-c -e . grep/test_dir/test_grep/test_1_grep.txt -e '.'"
"-l for no_file.txt grep/test_dir/test_grep/test_2_grep.txt"
"-f grep/test_dir/test_grep/test_3_grep.txt grep/test_dir/test_grep/test_5_grep.txt"
)

testing()
{
    t=$(echo $@ | sed "s/VAR/$var/")
    valgrind --leak-check=full \
                      --show-leak-kinds=all \
                      --log-file=valgrind-out.txt \
                      ./main $t
    RES="$(grep -e "ERROR SUMMARY" valgrind-out.txt)"
    cat valgrind-out.txt
    (( COUNTER++ ))
    if [[ $RES == *"0 errors from 0 contexts"* ]]
    then
      (( SUCCESS++ ))
      echo "$FAIL/$SUCCESS/$COUNTER success"
    else
      (( FAIL++ ))
       echo "$FAIL/$SUCCESS/$COUNTER fail"
    fi
#    rm test_s21_grep.log test_sys_grep.log

}



# специфические тесты
for i in "${extra[@]}"
do
    var="-"
    testing $i
done

# 1 параметр
for var1 in v c l n h o
do
    for i in "${tests[@]}"
    do
        var="-$var1"
        testing $i
    done
done

# 2 параметра
for var1 in v c l n h o
do
    for var2 in v c l n h o
    do
        if [ $var1 != $var2 ]
        then
            for i in "${tests[@]}"
            do
                var="-$var1 -$var2"
                testing $i
            done
        fi
    done
done

# 3 параметра
for var1 in v c l n h o
do
    for var2 in v c l n h o
    do
        for var3 in v c l n h o
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
for var1 in v c l n h o
do
    for var2 in v c l n h o
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
for var1 in v c l n h o
do
    for var2 in v c l n h o
    do
        for var3 in v c l n h o
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

echo "FAIL: $FAIL"
echo "SUCCESS: $SUCCESS"
echo "ALL: $COUNTER"

ls -l


SUCCESS=0
FAIL=0
COUNTER=0
DIFF_RES=""

declare -a tests=(
"'Ms. ' grep/datasets/data1"
"'butt' grep/datasets/data2"
"'e' grep/datasets/data1"
"'q' grep/datasets/data2"
"'d' grep/datasets/data1"
"'qwe' grep/datasets/data2"

"'Ms. ' grep/datasets/data1 grep/datasets/data2"
"'butt' grep/datasets/data2 grep/datasets/data2"
"'e' grep/datasets/data1 grep/datasets/data2"
"'q' grep/datasets/data2 grep/datasets/data2"
"'d' grep/datasets/data1 grep/datasets/data2"
"'qwe' grep/datasets/data2 grep/datasets/data2"

"'Ms. ' grep/datasets/data1 grep/datasets/data2 -f nonexistent.file"
"'butt' grep/datasets/data2 grep/datasets/data2 qwe"
"'e' grep/datasets/data1 grep/datasets/data2 some_bullshit.txt"
"'q' grep/datasets/data2 grep/datasets/data2 ()"
"'qwe' grep/datasets/data2 grep/datasets/data2 >.<"

"'string' grep/datasets/multipleMathesInARow"
"'qwe' grep/datasets/qwerty.txt"
"'stuff' grep/datasets/stuffFile"
"'q' grep/datasets/data2"
"'d' grep/datasets/data1"
"'qwe' grep/datasets/data2"

"'god' grep/datasets/TheDreamQuestOfUnknownKadath grep/datasets/TheOtherGods"
"'dark' grep/datasets/TheDreamQuestOfUnknownKadath grep/datasets/TheOtherGods"
"'darkness' grep/datasets/TheDreamQuestOfUnknownKadath grep/datasets/TheOtherGods"
"'abyss' grep/datasets/TheDreamQuestOfUnknownKadath grep/datasets/TheOtherGods"
)

testing()
{
    t=$(echo $@ | sed "s/VAR/$var/")
    ./grep/s21_grep $t > test_s21_grep.log
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


for var1 in e i v c l n
do
    for i in "${tests[@]}"
    do
        var="-$var1"
        testing $i
    done
done
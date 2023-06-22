SUCCESS=0
FAIL=0
COUNTER=0
DIFF_RES=""

declare -a tests=(
  " -e 'Ms. ' grep/datasets/data1"
  " -e 'butt' grep/datasets/data2"
  " -e 'e' grep/datasets/data1"
  " -e 'q' grep/datasets/data2"
  " -e 'd' grep/datasets/data1"
  " -e 'qwe' grep/datasets/data2"

  " -e 'Ms. ' grep/datasets/data1 grep/datasets/data2"
  " -e 'butt' grep/datasets/data2 grep/datasets/data2"
  " -e 'e' grep/datasets/data1 grep/datasets/data2"
  " -e 'q' grep/datasets/data2 grep/datasets/data2"
  " -e 'd' grep/datasets/data1 grep/datasets/data2"
  " -e 'qwe' grep/datasets/data2 grep/datasets/data2"

  " -e 'Ms. ' grep/datasets/data1 grep/datasets/data2 -f nonexistent.file"
  " -e 'butt' grep/datasets/data2 grep/datasets/data2 qwe"
  " -e 'e' grep/datasets/data1 grep/datasets/data2 some_bullshit.txt"
  " -e 'q' grep/datasets/data2 grep/datasets/data2 ()"
  " -e 'qwe' grep/datasets/data2 grep/datasets/data2 >.<"

  " -e 'string' ./datasets/multipleMathesInARow"
  " -e 'qwe' ./datasets/qwerty.txt"
  " -e 'stuff' ./datasets/stuffFile"
  " -e 'q' grep/datasets/data2"
  " -e 'd' grep/datasets/data1"
  " -e 'qwe' grep/datasets/data2"

  " -e 'god' grep/datasets/TheDreamQuestOfUnknownKadath grep/datasets/TheOtherGods"
  " -e 'dark' grep/datasets/TheDreamQuestOfUnknownKadath grep/datasets/TheOtherGods"
  " -e 'darkness' grep/datasets/TheDreamQuestOfUnknownKadath grep/datasets/TheOtherGods"
  " -e 'abyss' grep/datasets/TheDreamQuestOfUnknownKadath grep/datasets/TheOtherGods"
)

declare -a tests_extra=(
  " -e Ms.  -h grep/datasets/data1"
  " -e butt -h grep/datasets/data2"
  " -e e -h grep/datasets/data1"
  " -e q -h grep/datasets/data2"
  " -e d -h grep/datasets/data1"
  " -e qwe -h grep/datasets/data2"

  " -e Ms.  -h grep/datasets/data1 grep/datasets/data2"
  " -e butt -h grep/datasets/data2 grep/datasets/data2"
  " -e e -h grep/datasets/data1 grep/datasets/data2"
  " -e q -h grep/datasets/data2 grep/datasets/data2"
  " -e d -h grep/datasets/data1 grep/datasets/data2"
  " -e qwe -h grep/datasets/data2 grep/datasets/data2"

  " -e Ms.  -h grep/datasets/data1 grep/datasets/data2 -f nonexistent.file"
  " -e butt -h grep/datasets/data2 grep/datasets/data2 qwe"
  " -e e -h grep/datasets/data1 grep/datasets/data2 some_bullshit.txt"
  " -e q -h grep/datasets/data2 grep/datasets/data2 ()"
  " -e qwe -h grep/datasets/data2 grep/datasets/data2 >.<"

  " -e string -h ./datasets/multipleMathesInARow"
  " -e qwe -h ./datasets/qwerty.txt"
  " -e stuff -h ./datasets/stuffFile"
  " -e q -h grep/datasets/data2"
  " -e d -h grep/datasets/data1"
  " -e qwe -h grep/datasets/data2"

  " -e god -h grep/datasets/TheDreamQuestOfUnknownKadath grep/datasets/TheOtherGods"
  " -e dark -h grep/datasets/TheDreamQuestOfUnknownKadath grep/datasets/TheOtherGods"
  " -e darkness -h grep/datasets/TheDreamQuestOfUnknownKadath grep/datasets/TheOtherGods"
  " -e abyss -h grep/datasets/TheDreamQuestOfUnknownKadath grep/datasets/TheOtherGods"

  " -e Ms.  -s grep/datasets/data1"
  " -e butt -s grep/datasets/data2"
  " -e e -s grep/datasets/data1"
  " -e q -s grep/datasets/data2"
  " -e d -s grep/datasets/data1"
  " -e qwe -s grep/datasets/data2"

  " -e Ms.  -s grep/datasets/data1 grep/datasets/data2"
  " -e butt -s grep/datasets/data2 grep/datasets/data2"
  " -e e -s grep/datasets/data1 grep/datasets/data2"
  " -e q -s grep/datasets/data2 grep/datasets/data2"
  " -e d -s grep/datasets/data1 grep/datasets/data2"
  " -e qwe -s grep/datasets/data2 grep/datasets/data2"

  " -e Ms.  -s grep/datasets/data1 grep/datasets/data2 -f nonexistent.file"
  " -e butt -s grep/datasets/data2 grep/datasets/data2 qwe"
  " -e e -s grep/datasets/data1 grep/datasets/data2 some_bullshit.txt"
  " -e q -s grep/datasets/data2 grep/datasets/data2 ()"
  " -e qwe -s grep/datasets/data2 grep/datasets/data2 >.<"

  " -e string -s ./datasets/multipleMathesInARow"
  " -e qwe -s ./datasets/qwerty.txt"
  " -e stuff -s ./datasets/stuffFile"
  " -e q -s grep/datasets/data2"
  " -e d -s grep/datasets/data1"
  " -e qwe -s grep/datasets/data2"

  " -e god -s grep/datasets/TheDreamQuestOfUnknownKadath grep/datasets/TheOtherGods"
  " -e dark -s grep/datasets/TheDreamQuestOfUnknownKadath grep/datasets/TheOtherGods"
  " -e darkness -s grep/datasets/TheDreamQuestOfUnknownKadath grep/datasets/TheOtherGods"
  " -e abyss -s grep/datasets/TheDreamQuestOfUnknownKadath grep/datasets/TheOtherGods"

  \
  " -e Ms.  -o grep/datasets/data1"
  " -e butt -o grep/datasets/data2"
  " -e e -o grep/datasets/data1"
  " -e q -o grep/datasets/data2"
  " -e d -o grep/datasets/data1"
  " -e qwe -o grep/datasets/data2"

  " -e q -o grep/datasets/data2 grep/datasets/data2"
  " -e qwe -o grep/datasets/data2 grep/datasets/data2"

  " -e Ms.  -o grep/datasets/data1 grep/datasets/data2 -f nonexistent.file"
  " -e q -o grep/datasets/data2 grep/datasets/data2 ()"
  " -e qwe -o grep/datasets/data2 grep/datasets/data2 >.<"

  " -e string -o ./datasets/multipleMathesInARow"
  " -e qwe -o ./datasets/qwerty.txt"
  " -e stuff -o ./datasets/stuffFile"
  " -e q -o grep/datasets/data2"
  " -e d -o grep/datasets/data1"
  " -e qwe -o grep/datasets/data2"

  " -e Ms.  -f grep/test_dir/pattern grep/datasets/data1"
  " -e butt -f grep/test_dir/pattern grep/datasets/data2"
  " -e e -f grep/test_dir/pattern grep/datasets/data1"
  " -e q -f grep/test_dir/pattern grep/datasets/data2"
  " -e d -f grep/test_dir/pattern grep/datasets/data1"
  " -e qwe -f grep/test_dir/pattern grep/datasets/data2"

  " -e Ms.  -f grep/test_dir/pattern grep/datasets/data1 grep/datasets/data2"
  " -e butt -f grep/test_dir/pattern grep/datasets/data2 grep/datasets/data2"
  " -e e -f grep/test_dir/pattern grep/datasets/data1 grep/datasets/data2"
  " -e q -f grep/test_dir/pattern grep/datasets/data2 grep/datasets/data2"
  " -e d -f grep/test_dir/pattern grep/datasets/data1 grep/datasets/data2"
  " -e qwe -f grep/test_dir/pattern grep/datasets/data2 grep/datasets/data2"

  " -e Ms.  -f grep/test_dir/pattern grep/datasets/data1 grep/datasets/data2 -f nonexistent.file"
  " -e butt -f grep/test_dir/pattern grep/datasets/data2 grep/datasets/data2 qwe"
  " -e e -f grep/test_dir/pattern grep/datasets/data1 grep/datasets/data2 some_bullshit.txt"
  " -e q -f grep/test_dir/pattern grep/datasets/data2 grep/datasets/data2 ()"
  " -e qwe -f grep/test_dir/pattern grep/datasets/data2 grep/datasets/data2 >.<"

  " -e string -f grep/test_dir/pattern ./datasets/multipleMathesInARow"
  " -e stuff -f grep/test_dir/pattern ./datasets/stuffFile"
  " -e q -f grep/test_dir/pattern grep/datasets/data2"
  " -e d -f grep/test_dir/pattern grep/datasets/data1"
  " -e qwe -f grep/test_dir/pattern grep/datasets/data2"

  " -e god -f grep/test_dir/pattern grep/datasets/TheDreamQuestOfUnknownKadath grep/datasets/TheOtherGods"
  " -e dark -f grep/test_dir/pattern grep/datasets/TheDreamQuestOfUnknownKadath grep/datasets/TheOtherGods"
  " -e darkness -f grep/test_dir/pattern grep/datasets/TheDreamQuestOfUnknownKadath grep/datasets/TheOtherGods"
  " -e abyss -f grep/test_dir/pattern grep/datasets/TheDreamQuestOfUnknownKadath grep/datasets/TheOtherGods"
)

testing() {
  t=$(echo $@ | sed "s/VAR/$var/")
  leaks -quiet -atExit -- ./grep/s21_grep $t >test_s21_grep.log
  leak=$(grep -e "total leaked bytes" test_s21_grep.log)
  ((COUNTER++))
  if [[ $leak == *"0 leaks for 0 total leaked bytes"* ]]; then
    ((SUCCESS++))
    echo "\033[31m$FAIL\033[0m/\033[32m$SUCCESS\033[0m/$COUNTER \033[32msuccess\033[0m ./grep/s21_grep $t"
  else
    ((FAIL++))
    echo "\033[31m$FAIL\033[0m/\033[32m$SUCCESS\033[0m/$COUNTER \033[31mfail\033[0m ./grep/s21_grep $t"
    #        echo "$leak"
  fi
  rm test_s21_grep.log
}

for var1 in e i v c l n; do
  for i in "${tests[@]}"; do
    var="-$var1"
    testing $i
  done
done

# shellcheck disable=SC2043
for var2 in e; do
  for i in "${tests_extra[@]}"; do
    var="-$var2"
    testing $i
  done
done

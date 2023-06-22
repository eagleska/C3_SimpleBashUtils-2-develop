CC=gcc
CFLAGS=-c -Wall -Wextra -Werror -std=c11

s21_grep: main_grep
	$(CC) s21_grep.o -o s21_grep
	rm -rf *.o

main_grep:
	$(CC) $(CFLAGS) s21_grep.c

rebuild: clean s21_grep

clean:
	rm -rf *.o s21_grep
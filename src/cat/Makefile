CC=gcc
CFLAGS=-c -Wall -Wextra -Werror -std=c11

s21_cat: main_cat
	$(CC) s21_cat.o -o s21_cat
	rm -rf *.o

main_cat:
	$(CC) $(CFLAGS) s21_cat.c

rebuild: clean s21_cat

clean:
	rm s21_cat
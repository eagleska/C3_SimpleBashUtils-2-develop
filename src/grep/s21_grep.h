#ifndef S21_GREP_H
#define S21_GREP_H

#include <getopt.h>
#include <regex.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define SIZE 4096
#define PATTERN_SIZE 512
#define errorCode_allocFailed -1
typedef struct Flags {
  int flag_e;
  int flag_i;
  int flag_v;
  int flag_c;
  int flag_l;
  int flag_n;
  int flag_h;
  int flag_s;
} Flags;
typedef struct {
  int count_n;
  int count_l;
  int count_c;
  int files;
  int numb_e;
  int error;
  int error_l;
  int error_v;
  int skip_file;
} Counts;

void parser(int, int *, char *[], Flags *, Counts *, char**);
void f_open(int, int, char *[], Flags *, Counts *,  char**);
void workgrep(int, int, char *[], Flags *, Counts *, FILE *,
               char**);
int flag_i(Flags *);
void flag_e(int, int, char *[], char *, const char *, Flags *, Counts *);
void flag_v(int, int, char *[], char *, const char *, Flags *, Counts *);
void flag_c(int, int, char *[], Flags *, Counts *);

#endif
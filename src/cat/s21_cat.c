#include <getopt.h>
#include <stdio.h>
#include <stdlib.h>

void initflags(int, char *[], int *);
void workflag(int, char *[], int *);
void printcat(int, int, int, char);

int main(int argc, char *argv[]) {
  int flags[6] = {0};
  initflags(argc, argv, flags);
  workflag(argc, argv, flags);
  return 0;
}

void initflags(int argc, char *argv[], int *flags) {
  const struct option long_options[] = {{"number-nonblank", 0, &flags[0], 1},
                                        {"number", 0, &flags[2], 1},
                                        {"squeeze-blank", 0, &flags[3], 1},
                                        {NULL, 0, NULL, 0}};
  char fl;
  while ((fl = getopt_long(argc, argv, "+benstvTE", long_options, NULL)) !=
         -1) {
    if (fl == 'b') {
      flags[0] = 1;
    } else if (fl == 'e') {
      flags[1] = 1;
    } else if (fl == 'E') {
      flags[1] += 2;
    } else if (fl == 'n') {
      flags[2] = 1;
    } else if (fl == 's') {
      flags[3] = 1;
    } else if (fl == 't') {
      flags[4] = 1;
    } else if (fl == 'T') {
      flags[4] += 2;
    } else if (fl == 'v') {
      flags[5] = 1;
    }
  }
  if (flags[0] && flags[2]) {
    flags[2] = 0;
    flags[0] = 1;
  }
  if (flags[4] >= 2) {
    flags[5] = 0;
    flags[4] = 1;
  }
  if (flags[1] >= 2) {
    flags[5] = 0;
    flags[1] = 1;
  }
  if (flags[4]) {
    flags[5] = 1;
  }
  if (flags[1]) {
    flags[5] = 1;
  }
}

void workflag(int argc, char *argv[], int *flags) {
  FILE *fp;
  char ch_pre = '\n';
  char ch_now;
  for (int i = optind; i < argc; i++) {
    if ((fp = fopen(argv[i], "r")) != NULL) {
      int num_str = 1, flag_s = 0, tt = 0, vv = 0;
      ch_pre = '\n';
      while ((ch_now = fgetc(fp)) != EOF) {
        tt = 0;
        vv = 0;
        if (flags[3] && ch_now == '\n' && flag_s == 0) {  // s
          flag_s = 1;
        } else if (flags[3] && ch_now == '\n' && ch_pre == '\n') {
          flag_s++;
        } else if (flags[3] && ch_now != '\n' && ch_pre == '\n') {
          flag_s = 0;
        }
        if (flags[4] && (flag_s <= 2) && ch_now == 9) {  // t
          tt = 1;
        }
        if (flags[5] && (flag_s <= 2) && ch_now >= 0 && ch_now <= 31 &&
            ch_now != 9 && ch_now != 10) {  // v
          vv = 1;
        }
        if (flags[5] && (flag_s <= 2) && ch_now == 127) {  // v
          vv = 2;
        }
        if (flags[0] && ch_now != '\n' && ch_pre == '\n' && !flag_s) {  // b
          printf("%6d\t", num_str);
          num_str++;
        } else if (flags[2] && ch_pre == '\n' && (flag_s <= 2)) {  // n
          printf("%6d\t", num_str);
          num_str++;
        }
        if (flags[1] && (flag_s <= 2) && ch_now == '\n') {  // e
          printf("$");
        }
        ch_pre = ch_now;
        printcat(tt, vv, flag_s, ch_now);
      }
      fclose(fp);
    } else
      fprintf(stderr, "%s: %s: No such file or directory\n", argv[0], argv[i]);
  }
}

void printcat(int tt, int vv, int flag_s, char ch_now) {
  if (flag_s <= 2 && !tt && !vv) {
    printf("%c", ch_now);
  } else if (tt) {
    printf("^I");
  } else if (vv == 1) {
    printf("^%c", ch_now + 64);
  } else if (vv == 2) {
    printf("^?");
  }
}
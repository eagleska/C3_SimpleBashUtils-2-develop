#include "s21_grep.h"

Flags *initFlags(int *errorCode) {
  Flags *flags = calloc(1, sizeof(Flags));
  if (!flags) *errorCode = errorCode_allocFailed;
  return flags;
}

Counts *initCounts(int *errorCode) {
  Counts *counts = calloc(1, sizeof(Counts));
  if (!counts) *errorCode = errorCode_allocFailed;
  return counts;
}

int main(int argc, char *argv[]) {
  int index_files = 1;
  int errorCode = 0;
  Flags *flags = initFlags(&errorCode);
  Counts *counts = initCounts(&errorCode);
  char **pattern = calloc(512, sizeof(char *));
  for (int i = 0; i < 512; i++) pattern[i] = calloc(4096, sizeof(char));
  if (argc > 2) {
    parser(argc, &index_files, argv, flags, counts, pattern);
    f_open(argc, index_files, argv, flags, counts, pattern);
  } else {
    fprintf(stderr, "%s: option requires an argument -%s\n", argv[0], argv[1]);
  }
  free(flags);
  free(counts);
  for (int i = 0; i < 512; i++) free(pattern[i]);
  free(pattern);
  return 0;
}

void parser(int argc, int *index_files, char *argv[], Flags *flags,
            Counts *counts, char **pattern) {
  const struct option long_options[] = {{NULL, 0, NULL, 0}};
  int strin = 0;
  while ((strin = getopt_long(argc, argv, "e:ivclnhs", long_options, NULL)) !=
         -1) {
    if (strin == 'e') {
      flags->flag_e = 1;
      strcat(pattern[counts->numb_e], optarg);
      counts->numb_e++;
    } else if (strin == 'i') {
      flags->flag_i = 1;
    } else if (strin == 'v') {
      flags->flag_v = 1;
    } else if (strin == 'c') {
      flags->flag_c = 1;
    } else if (strin == 'l') {
      flags->flag_l = 1;
    } else if (strin == 'n') {
      flags->flag_n = 1;
    }
    if (strin == 's') {
      flags->flag_s = 1;
    }
    if (strin == 'h') {
      flags->flag_h = 1;
    }
  }
  *index_files = optind;
}

void f_open(int argc, int index_files, char *argv[], Flags *flags,
            Counts *counts, char **pattern) {
  if (!flags->flag_e) {
    strcat(pattern[0], argv[index_files]);
    counts->skip_file++;
  }
  for (int i = index_files; i < argc; i++) {
    if (!flags->flag_e && !counts->files && counts->skip_file) {
      i++;
    }
    if (argv[i][0] != '-') {
      FILE *fp;
      if ((fp = fopen(argv[i], "r")) == NULL && !flags->flag_s) {
        fprintf(stderr, "%s: %s: No such file or directory\n", argv[0],
                argv[i]);
        counts->skip_file = 0;
      } else {
        counts->skip_file++;
        workgrep(argc, i, argv, flags, counts, fp, pattern);
        fclose(fp);
      }
    }
  }
}

void workgrep(int argc, int index, char *argv[], Flags *flags, Counts *counts,
              FILE *fp, char **pattern) {
  int compFlags = 0;
  counts->count_n = 1, counts->count_c = 0, counts->error_l = 0;
  regex_t template;
  char string[SIZE];
  compFlags = flag_i(flags);
  counts->files++;
  while (fgets(string, SIZE, fp) != NULL && !counts->error_l) {
    const char *line;
    line = strchr(string, '\n');
    counts->error = 0, counts->error_v = 0;
    for (int k = 0; k <= counts->numb_e && !counts->error && !counts->error_l &&
                    !counts->error_v;
         ++k) {
      regcomp(&template, pattern[k], compFlags);
      int status = regexec(&template, string, 0, NULL, 0);
      if (!status && !flags->flag_v) {
        flag_e(argc, index, argv, string, line, flags, counts);
      }
      if (!status && flags->flag_v) {
        counts->error_v++;
        if (flags->flag_l && !flags->flag_v) counts->error_l++;
      }
      regfree(&template);
    }
    flag_v(argc, index, argv, string, line, flags, counts);
    counts->count_n++;
  }
  if (flags->flag_c) flag_c(argc, index, argv, flags, counts);
}

int flag_i(Flags *flags) {
  int reg = REG_EXTENDED | REG_NEWLINE;
  if (flags->flag_i) reg = REG_EXTENDED | REG_ICASE | REG_NEWLINE;
  return reg;
}

void flag_e(int argc, int index, char *argv[], char *string, const char *line,
            Flags *flags, Counts *counts) {
  if (flags->flag_c) counts->count_c++;
  if ((index + 1 < argc || counts->files > 1) && !flags->flag_h &&
      !flags->flag_c && !flags->flag_l) {
    printf("%s:", argv[index]);
  }
  if (flags->flag_l && !flags->flag_c) {
    printf("%s\n", argv[index]);
    counts->error_l++;
  }
  if (!counts->error_l) {
    if (!flags->flag_l && !flags->flag_c) {
      if (flags->flag_n) printf("%d:", counts->count_n);
      counts->error++;
      printf("%s", string);
      if (line == NULL) printf("\n");
    }
    if (flags->flag_c) counts->error++;
  }
}

void flag_v(int argc, int index, char *argv[], char *string, const char *line,
            Flags *flags, Counts *counts) {
  if (!counts->error_v && flags->flag_v) {
    if (flags->flag_c) {
      counts->count_c++;
    }
    if ((index + 1 < argc || counts->files > 1) && !flags->flag_h &&
        !flags->flag_c && !flags->flag_l) {
      printf("%s:", argv[index]);
    }
    if (flags->flag_l && !flags->flag_c) {
      printf("%s\n", argv[index]);
      counts->error_l++;
    }
    if (!counts->error_l) {
      if (!flags->flag_l && !flags->flag_c) {
        if (flags->flag_n) printf("%d:", counts->count_n);
        counts->error++;
        printf("%s", string);
        if (line == NULL) printf("\n");
      }
      if (flags->flag_c) counts->error++;
    }
  }
}

void flag_c(int argc, int index, char *argv[], Flags *flags, Counts *counts) {
  if ((index + 1 < argc || counts->files > 1) && !flags->flag_h) {
    printf("%s:", argv[index]);
  }
  if (!flags->flag_l) {
    printf("%d\n", counts->count_c);
  } else {
    if (counts->count_c > 0) {
      printf("1\n");
      if (flags->flag_l) {
        printf("%s\n", argv[index]);
      }
    } else
      printf("0\n");
  }
}
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

/*
 * This program should define a function that takes a string and returns a string that replaces letters with their alphabet position
 */

int digcount(int n) {
  int count=0;
  while (n) {n/=10; count++;}
  return count;
}

char* itoa(int n) {
  int digs = digcount(n);
  char* buff = malloc(digs+1);
  buff[digs] = 0;
  digs--;
  for (;digs>=0; digs--) {
    buff[digs] = n%10+'0';
    n/=10;
  }
  return buff;
}

char* alph(char* s) {
  char* buff = calloc(strlen(s)*3+1, 1);
  char* ptr = buff;
  for (int i=0; i<strlen(s); i++) {
    char ch = s[i];
    if (ch >= 'A' && ch <= 'Z') ch += 32;
    if (ch >= 'a' && ch <= 'z') {
      ch -= 96;
      ptr=stpcpy(ptr, itoa(ch));
      *ptr=' ';
      ptr++;
    }
  }
  return buff;
}

int main() {
  char* resp = alph("Hello world");
  printf("%s\n", resp);
}

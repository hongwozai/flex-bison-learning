%{
#include <stdio.h>
#include <string.h>

int num_lines = 0;
int num_chars = 0;
int num_words = 0;

%}

/* %array */
%option reentrant
%option noyywrap
%option yylineno

%%

   /* yyleng yytext */
[^ \t\n\v]+ ++num_words; num_chars += yyleng; ECHO; printf("\n");

    /* \n | */

\n ++num_lines; ++num_chars;

. ++num_chars;

%%

int main(int argc, char *argv[])
{
    FILE *in = NULL;
    if (argc >= 2) {
        in = fopen(argv[1], "r");
        if (!in) {
            printf("%s open failed: (%m)\n", argv[1]);
            return -1;
        }
    }
    yyscan_t scanner;
    yylex_init(&scanner);
    yyset_in(in, scanner);
    yylex(scanner);
    yylex_destroy(scanner);
    fclose(in);
    printf("lines: %d, words: %d, chars: %d\n",
           num_lines, num_words, num_chars);
    return 0;
}
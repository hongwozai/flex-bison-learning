%{
#define YYSTYPE double

#include <math.h>
#include <stdio.h>
int yylex();
int yyerror(const char *s);
%}
%token NUM
%%

input:                          /* empty */
        |       input line
        ;

line:           expr '\n'
                {
                    printf("\nexpr: %f\n", $1);
                }
        |       '\n'
        ;

expr:           NUM { $$ = $1;  printf(": num: %f\n", $1); }
        |       expr expr '+' { $$ = $1 + $2; printf("sss\n"); }
        |       expr expr '-' { $$ = $1 - $2; }
        |       expr expr '*' { $$ = $1 * $2; }
        |       expr expr '/' { $$ = $1 / $2; }
        |       expr 'n' { $$ = - $1; }
        ;

%%
int yyerror(const char *s) {
    printf("%s\n", s);
}
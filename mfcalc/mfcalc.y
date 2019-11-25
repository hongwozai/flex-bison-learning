%{
#include <math.h>
#include <stdio.h>
#include "calc.h"
int yylex();
int yyerror(const char *s);
%}

%right '='
%left '+' '-'
%left '*' '/'
%left MINUS
%right '^'
/* %nonassoc '^' */

%union {
    double val;
    struct symrec *tptr;
}

%token  <val>           NUM
%token  <tptr>          VAR FNCT
%type   <val>           expr
%%

input:                          /* empty */
        |       input line
        ;

line:           expr '\n'
                {
                    printf("expr: %f\n", $1);
                }
        |       '\n'
        |       error '\n' { printf("error\n"); yyerrok; }
        ;

expr:           NUM { $$ = $1; printf("NUM: (%lf)\n", $1); }
        |       VAR { $$ = $1->value.var; printf("var: %s\n", $1->name); }
        |       VAR '=' expr
                {
                    $$ = $3;
                    $1->value.var = $3;
                    printf("'%s = %lf'\n", $1->name, $1->value.var);
                }
        |       FNCT '(' expr ')'
                {
                    printf("call function %s(%lf)\n", $1->name, $3);
                    $$ = $1->value.fnctptr($3);
                }
        |       expr '+' expr { $$ = $1 + $3; printf("(%lf+%lf=%lf)\n", $1, $3, $$); }
        |       expr '-' expr { $$ = $1 - $3; printf("(%lf-%lf=%lf)\n", $1, $3, $$); }
        |       expr '*' expr { $$ = $1 * $3; printf("(*)\n"); }
        |       expr '/' expr
                {
                    if ($3) {
                        $$ = $1 / $3;
                    } else {
                        printf("(1: %lf) / (3: %lf), division by zero\n", $1, $3);
                        printf("position: %d.%d-%d.%d\n",
                               @3.first_line, @3.first_column,
                               @3.last_line, @3.last_column);
                    }
                    printf("(/)\n");
                }
        |       expr '^' expr { $$ = pow($1, $3); printf("(%lf^%lf)\n", $1, $3); }
        |       '-'expr %prec MINUS { $$ = - $2; printf("(MINUS(%lf=-%lf))\n", $$, $2); }
        ;

%%
int yyerror(const char *s) {
    printf("%s\n", s);
}
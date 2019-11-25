%{
#define YYSTYPE double

#include <math.h>
#include <stdio.h>
int yylex();
int yyerror(const char *s);
%}
%token NUM

%left '+' '-'
%left '*' '/'
%left MINUS
%right '^'
/* %nonassoc '^' */
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
        |       expr '+' expr { $$ = $1 + $3; printf("(%lf+%lf=%lf)\n", $1, $3, $$); }
        |       expr '-' expr { $$ = $1 - $3; printf("(%lf-%lf=%lf)\n", $1, $3, $$); }
        |       expr '*' expr { $$ = $1 * $3; printf("(*)\n"); }
        |       expr '/' expr
                {
                    if ($3) {
                        $$ = $1 / $3;
                    } else {
                        printf("(1: %lf) / (3: %lf), division by zero\n", $1, $3);
                        printf("position: %ld.%ld-%ld.%ld\n",
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
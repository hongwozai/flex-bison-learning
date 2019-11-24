%{
#define YYSTYPE double
#include <stdio.h>
#include "rpcalc.yy.h"
%}
%option noyywrap
%option yylineno

%%

[0-9]+ {
 yylval = atof(yytext);
 printf("(%s)yylval: %lf\n", yytext, yylval);
 return NUM;
}

[ \t]+ ;                    /* skip */

\n return '\n';

. return yytext[0];

%%
int main(int argc, char *argv[])
{
    if (argc >= 2) {
        yyin = fopen(argv[1], "r");
        if (!yyin) {
            printf("%s open failed: (%m)\n", argv[1]);
            return -1;
        }
    }
    yyparse();
    return 0;
}
%{
#include <stdio.h>
#include "mfcalc.yy.h"
#include "calc.h"
%}
%option noyywrap
%option yylineno

%%

[a-zA-Z][a-zA-Z0-9]+ {
 symrec *ptr = getsym(yytext);
 if (ptr) {
  yylval.tptr = ptr;
 } else {
  ptr = putsym(yytext, VAR);
  yylval.tptr = ptr;
 }
 return ptr->type;
}

[0-9]+ {
 yylval.val = atof(yytext);
 yylloc.first_column ++;
 yylloc.last_column += yyleng;
 return NUM;
 }

    /* skip */
[ \t]+ yylloc.last_column+=yyleng; yylloc.first_column+=yyleng;

\n yylloc.first_line++; yylloc.last_line++; yylloc.first_column = yylloc.last_column = 0; return '\n';

. yylloc.first_column++; yylloc.last_column++; return yytext[0];

%%

int main(int argc, char *argv[])
{
    init_table();
    if (argc >= 2) {
        yyin = fopen(argv[1], "r");
        if (!yyin) {
            printf("%s open failed: (%m)\n", argv[1]);
            return -1;
        }
    }
    yylloc.first_line = 1;
    yylloc.first_column = 0;
    yylloc.last_line = 1;
    yylloc.last_column = 0;
    yyparse();
    return 0;
}
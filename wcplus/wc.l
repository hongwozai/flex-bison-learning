%{
#include <cstdio>
#include <iostream>
#include <fstream>

int num_lines = 0;
int num_chars = 0;
int num_words = 0;

%}

/* %array */
%option c++
%option noyywrap
%option yylineno

%%

   /* yyleng yytext */
[^ \t\n\v]+ ++num_words; num_chars += YYLeng(); ECHO; printf("(%d)\n", lineno());

    /* \n | */

\n ++num_lines; ++num_chars;

. ++num_chars;

%%

using namespace std;
int main(int argc, char *argv[])
{
    ifstream yyin;
    if (argc >= 2) {
        yyin.open(argv[1], ios::in);
        if (!yyin.is_open()) {
            printf("%s open failed: (%m)\n", argv[1]);
            return -1;
        }
    }
    FlexLexer *lexer = new yyFlexLexer(yyin, cout);
    lexer->yylex();
    printf("lines: %d, words: %d, chars: %d\n",
           num_lines, num_words, num_chars);
    return 0;
}
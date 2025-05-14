%{
#include "newlang.tab.h"
#include <string.h>
int line_num = 1;
%}

%%
"start"       { return START; }
"stop"        { return STOP; }
"var"         { return VAR; }
"if"          { return IF; }
"else"        { return ELSE; }
"loop"        { return LOOP; }
"while"       { return WHILE; }
"+"           { return PLUS; }
"-"           { return MINUS; }
"*"           { return MULT; }
"/"           { return DIV; }
"="           { return ASSIGN; }
">"           { return GT; }
"<"           { return LT; }
">="          { return GE; }
"<="          { return LE; }
"=="          { return EQ; }
"!="          { return NE; }
"{"           { return '{'; }
"}"           { return '}'; }
[0-9]+        { yylval.str = strdup(yytext); return NUMBER; }
[a-zA-Z][a-zA-Z0-9]*  { yylval.str = strdup(yytext); return ID; }
[ \t]         ;   // skip whitespace
\n            { line_num++; }  
"//"[^\n]*    ;   // single line comments
"/*"([^*]|"*"[^/])*"*/"  ;   // multi-line comments
.             { printf("Unknown character: %s\n", yytext); }
%%

int yywrap() {
    return 1;
}
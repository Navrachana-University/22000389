%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// External variables from lexer
extern FILE *yyin;
extern FILE *yyout;
extern int yylex();
extern int line_num;

// Function declarations
void yyerror(const char *s);
char* newTemp();
char* newLabel();

// Global counters
int tempCount = 1;
int labelCount = 1;

// Global variables for control flow labels
char* if_else_end;
char* else_label;
char* loop_start;
char* loop_test;
char* loop_end;
%}

%union {
    char* str;
}

%token <str> ID NUMBER
%token START STOP VAR IF ELSE LOOP WHILE
%token PLUS MINUS MULT DIV ASSIGN
%token GT LT GE LE EQ NE

%type <str> expr condition

/* Define operator precedence to resolve conflicts */
%left PLUS MINUS
%left MULT DIV
%nonassoc LT GT LE GE EQ NE
%right ASSIGN

%%
program
    : START statement_list STOP
    ;

statement_list
    : statement
    | statement_list statement
    ;

statement
    : declaration
    | assignment
    | if_statement
    | loop_statement
    | '{' statement_list '}'  /* Allow block statements */
    ;

declaration
    : VAR ID ASSIGN expr {
        fprintf(yyout, "%s = %s\n", $2, $4);
    }
    ;

assignment
    : ID ASSIGN expr {
        fprintf(yyout, "%s = %s\n", $1, $3);
    }
    ;

if_statement
    : IF condition {
        char* true_label = newLabel();
        char* false_label = newLabel();
        char* end_label = newLabel();
        
        // Store labels in global variables
        else_label = false_label;
        if_else_end = end_label;
        
        fprintf(yyout, "if %s goto %s\n", $2, true_label);
        fprintf(yyout, "goto %s\n", false_label);
        fprintf(yyout, "%s:\n", true_label);
    } 
    statement else_part
    ;

else_part
    : ELSE {
        fprintf(yyout, "goto %s\n", if_else_end);
        fprintf(yyout, "%s:\n", else_label);
    }
    statement {
        fprintf(yyout, "%s:\n", if_else_end);
    }
    | /* empty */ {
        fprintf(yyout, "%s:\n", else_label);
        fprintf(yyout, "%s:\n", if_else_end);
    }
    ;

loop_statement
    : LOOP WHILE {
        loop_start = newLabel();
        loop_test = newLabel();
        loop_end = newLabel();
        
        fprintf(yyout, "%s:\n", loop_start);
    }
    condition {
        fprintf(yyout, "if %s goto %s\n", $4, loop_test);
        fprintf(yyout, "goto %s\n", loop_end);
        fprintf(yyout, "%s:\n", loop_test);
    }
    statement {
        fprintf(yyout, "goto %s\n", loop_start);
        fprintf(yyout, "%s:\n", loop_end);
    }
    ;

condition
    : expr GT expr {
        char* temp = newTemp();
        fprintf(yyout, "%s = %s > %s\n", temp, $1, $3);
        $$ = temp;
    }
    | expr LT expr {
        char* temp = newTemp();
        fprintf(yyout, "%s = %s < %s\n", temp, $1, $3);
        $$ = temp;
    }
    | expr GE expr {
        char* temp = newTemp();
        fprintf(yyout, "%s = %s >= %s\n", temp, $1, $3);
        $$ = temp;
    }
    | expr LE expr {
        char* temp = newTemp();
        fprintf(yyout, "%s = %s <= %s\n", temp, $1, $3);
        $$ = temp;
    }
    | expr EQ expr {
        char* temp = newTemp();
        fprintf(yyout, "%s = %s == %s\n", temp, $1, $3);
        $$ = temp;
    }
    | expr NE expr {
        char* temp = newTemp();
        fprintf(yyout, "%s = %s != %s\n", temp, $1, $3);
        $$ = temp;
    }
    ;

expr
    : ID {
        $$ = $1;
    }
    | NUMBER {
        char* temp = newTemp();
        fprintf(yyout, "%s = %s\n", temp, $1);
        $$ = temp;
    }
    | expr PLUS expr {
        char* temp = newTemp();
        fprintf(yyout, "%s = %s + %s\n", temp, $1, $3);
        $$ = temp;
    }
    | expr MINUS expr {
        char* temp = newTemp();
        fprintf(yyout, "%s = %s - %s\n", temp, $1, $3);
        $$ = temp;
    }
    | expr MULT expr {
        char* temp = newTemp();
        fprintf(yyout, "%s = %s * %s\n", temp, $1, $3);
        $$ = temp;
    }
    | expr DIV expr {
        char* temp = newTemp();
        fprintf(yyout, "%s = %s / %s\n", temp, $1, $3);
        $$ = temp;
    }
    ;

%%

char* newTemp() {
    char* buffer = malloc(10);
    sprintf(buffer, "t%d", tempCount++);
    return buffer;
}

char* newLabel() {
    char* buffer = malloc(10);
    sprintf(buffer, "L%d", labelCount++);
    return buffer;
}

void yyerror(const char *s) {
    fprintf(stderr, "Error at line %d: %s\n", line_num, s);
}

int main() {
    yyin = fopen("input.txt", "r");
    yyout = fopen("output.txt", "w");
    
    if (!yyin) {
        fprintf(stderr, "Could not open input.txt\n");
        return 1;
    }
    
    if (!yyout) {
        fprintf(stderr, "Could not create output.txt\n");
        return 1;
    }
    
    yyparse();
    
    fclose(yyin);
    fclose(yyout);
    return 0;
}
%{
        #include <stdio.h>
        #include <string.h>
        #include "symbol.tab.h"

	extern int yylex();
	extern void yyerror (char const *);
%}

%define parse.error verbose

%union {
        char* string;
}

%union {
        float float_t;
        int int_t;
}


%union {
        struct identifier
        {
                char *name;
                float value;
        } identifier;
}

%token <float_t> NUM_REAL
%token <int_t> NUM_INT
%token <identifier> ID
%token <string> LOG SIN COS TAN SQRT
%token PAR_OPEN PAR_CLOSED PRINT NEW_LINE

%type <float_t> expr factor term stmt
%type <identifier> lvalue rvalue
%type <string> assign func

%right <string> ASSIGN ASSIGN_PLUS ASSIGN_MINUS ASSIGN_MUL ASSIGN_DIV
%left '+' '-' 
%left '*' '/'
%nonassoc UMINUS

%start Start

%%

Start   : stmt
        | stmt NEW_LINE Start
        | NEW_LINE Start
        ;

assign  : ASSIGN
        | ASSIGN_PLUS
        | ASSIGN_MINUS
        | ASSIGN_MUL
        | ASSIGN_DIV
        ;

func    : LOG
        | SIN
        | COS
        | TAN
        | SQRT

stmt    : PRINT rvalue { printValue($2.name); }
        | lvalue assign stmt { $$ = $3; assignment($1.name, $2, $3); }
        | lvalue assign expr { $$ = $3; assignment($1.name, $2, $3); }
        ;

lvalue  : ID
        ;

rvalue  : ID 
                { 
                        token *t = findToken($1.name);

                        if(t != NULL)
                                $$.value = t->value;
                }
        ;   

expr    : expr '+' term { $$ = $1 + $3; }
        | expr '-' term { $$ = $1 - $3; }
        | term
        ;

term    : term '*' factor { $$ = $1 * $3; }
        | term '/' factor { $$ = $1 / $3; }
        | '-' term %prec UMINUS { $$ = -$2; }
        | factor
        ;

factor  : rvalue { $$ = $1.value; }
        | NUM_INT { $$ = (float)$1; }
        | NUM_REAL { $$ = $1; }
        | PAR_OPEN expr PAR_CLOSED { $$ = $2; }
        | func PAR_OPEN expr PAR_CLOSED { $$ = callFn($1, $3);}
        ;

%%

void yyerror (char const *s)
{ 
	fprintf(stderr, "Error: %s\n", s);
}
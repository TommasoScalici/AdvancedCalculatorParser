%{
        #include <stdio.h>
        #include <string.h>
        #include "symbol.tab.h"

	int yylex();
	void yyerror (char const *);
%}

%define parse.error verbose

%union {
    float float_t;
    int int_t;
}

%union {
        char *string;
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
%token NEW_LINE PAR_OPEN PAR_CLOSED PRINT

%type <float_t> expr factor term stmt
%type <identifier> lvalue rvalue
%type <string> assign

%right <string> ASSIGN ASSIGN_PLUS ASSIGN_MINUS ASSIGN_MUL ASSIGN_DIV
%left <string> PLUS MINUS
%left <string> MUL DIV
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

stmt    : PRINT rvalue { printValue($2.name); }
        | lvalue assign stmt { $$ = $3; assignment($1.name, $2, $3); }
        | lvalue assign expr { $$ = $3; assignment($1.name, $2, $3); }
        ;

lvalue  : ID
        ;

rvalue  : ID { 
                token *t = findToken($1.name);

                if(t != NULL)
                        $$.value = t->value; }
        ;   

expr    : expr PLUS term { $$ = $1 + $3; }
        | expr MINUS term { $$ = $1 - $3; }
        | term
        ;

term    : term MUL factor { $$ = $1 * $3; }
        | term DIV factor { $$ = $1 / $3; }
        | factor
        ;

factor  : rvalue { $$ = $1.value; }
        | NUM_INT { $$ = (float)$1; }
        | NUM_REAL { $$ = $1; }
        | PAR_OPEN expr PAR_CLOSED { $$ = $2; }
        ;

%%

char* concat(char *str1, char *str2)
{
        char *dest = malloc(sizeof(char) * (strlen(str1) + strlen(str2)));
        strcpy(dest, str1);
        return strcat(dest, str2);
}

void yyerror (char const *s)
{ 
	fprintf(stderr, "%s\n", s);
}

int main()
{
	yyparse();
	return 0; 
}
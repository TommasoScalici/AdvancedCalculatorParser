flexbison:
	flex lexer.fl
	bison -d --graph -v parser.y
	gcc -g -o result lex.yy.c parser.tab.c symbol.tab.c -lm
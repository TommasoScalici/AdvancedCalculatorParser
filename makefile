flexbison:
	flex lexer.fl
	bison -d parser.y
	gcc -o result lex.yy.c parser.tab.c symbol.tab.c
	./result < input.txt
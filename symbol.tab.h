typedef struct token
{
        char *name;
        float value;
} token;

void addOrUpdateToken(token);
void assignment(char *, char *, float);
float callFn(char *, float);
token *findToken(char *);
void printValue(char *);
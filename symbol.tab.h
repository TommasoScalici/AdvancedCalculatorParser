typedef struct token
{
        char *name;
        float value;
} token;

void addOrUpdateToken(token);
void assignment(char *, char *, float);
token *findToken(char *);
void printValue(char *);
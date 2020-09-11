#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "symbol.tab.h"

#define SIZE 100

size_t count = 0;
token table[SIZE];

void addOrUpdateToken(token t)
{
    token *tok = findToken(t.name);

    if(tok == NULL)
        table[count++] = t;
    else
        tok->value = t.value;
}

void assignment(char *name, char *sign, float value)
{
        token t;
        t.name = name;

        if(!strcmp(sign, "="))
        {
                t.value = value;
                addOrUpdateToken(t);
        }
        else
        {
                token *t2 = findToken(name);

                if(t2 != NULL)
                {
                        t.value = t2->value;

                        if(!strcmp(sign, "+="))
                                t.value += value;
                        if(!strcmp(sign, "-="))
                                t.value -= value;
                        if(!strcmp(sign, "*="))
                                t.value *= value;
                        if(!strcmp(sign, "/="))
                                t.value /= value;

                        addOrUpdateToken(t);
                }
                else
                        fprintf(stderr, "\n%s = non inizializzata\n", name);
        }
}

float callFn(char *functionName, float expr)
{
        float result = 0;

        if(!strcmp(functionName, "log"))
                result = log(expr);
        if(!strcmp(functionName, "sin"))
                result = sin(expr);
        if(!strcmp(functionName, "cos"))
                result = cos(expr);
        if(!strcmp(functionName, "tan"))
                result = tan(expr);
        if(!strcmp(functionName, "sqrt"))
                result = sqrt(expr);

        return result;
}

token *findToken(char *name)
{
    for (size_t i = 0; i < count; i++)
    {
        if(!strcmp(table[i].name, name))
            return &table[i];
    }

    return NULL;
}

void printValue(char *idName)
{
    token *tok = findToken(idName);

    if(tok != NULL)
        printf("\n%s = %.2f\n", tok->name, tok->value);
    else
        fprintf(stderr, "\n%s = non dichiarata.\n", idName);
}
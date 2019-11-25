#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <string.h>
#include "calc.h"
#include "mfcalc.yy.h"

struct init
{
    char const *fname;
    double (*fnct) (double);
};

struct init const arith_fncts[] =
{
    "sin",  sin,
    "cos",  cos,
    "atan", atan,
    "ln",   log,
    "exp",  exp,
    "sqrt", sqrt,
    0, 0
};

/* The symbol table: a chain of `struct symrec'.  */
/* 符号表: `struct symrec'链表 */
symrec *sym_table;

/* Put arithmetic functions in table.  */
/* 将数学函数放入符号表(注:保留字的实现方式) */
void
init_table (void)
{
    int i;
    symrec *ptr;
    for (i = 0; arith_fncts[i].fname != 0; i++)
    {
        ptr = putsym (arith_fncts[i].fname, FNCT);
        ptr->value.fnctptr = arith_fncts[i].fnct;
    }
}

symrec *
putsym (char const *sym_name, int sym_type)
{
    symrec *ptr;
    ptr = (symrec *) malloc (sizeof (symrec));
    ptr->name = (char *) malloc (strlen (sym_name) + 1);
    strcpy (ptr->name,sym_name);
    ptr->type = sym_type;
    ptr->value.var = 0; /* Set value to 0 even if fctn.  */ /* 置0即使是fctn */
    ptr->next = (struct symrec *)sym_table;
    sym_table = ptr;
    return ptr;
}

symrec *
getsym (char const *sym_name)
{
    symrec *ptr;
    for (ptr = sym_table; ptr != (symrec *) 0;
         ptr = (symrec *)ptr->next)
        if (strcmp (ptr->name,sym_name) == 0)
            return ptr;
    return 0;
}
%{
#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include "timers.h"
#include "grammar.h"

#define YYMAXDEPTH 1000000

#define DEBUG 0

extern FILE *yyin;

token_node *bison_tree;

void dump_tree(token_node *tree, uint32_t level)
{
#if DEBUG
	uint32_t itr;
    token_node *child_itr = NULL;

	for (itr = 0; itr < level; itr++) {
		fprintf(stderr, "\t");
	}
	if (tree->value != NULL) {
		fprintf(stderr, "<%s>\n", (char *)tree->value);
	} else {
		fprintf(stderr, "<%u>\n", tree->token);
    }
    child_itr = tree->child;
	while (child_itr != NULL && child_itr->parent == tree) {
		dump_tree(child_itr, level + 1);
        child_itr = child_itr->next;
	}
#endif
}

%}

%union {
	token_node *node;
}

%token <node> LBR; 
%token <node> RBR; 
%token <node> LSQ;
%token <node> RSQ;
%left  <node> COM;  
%left  <node> COL;  
%token <node> BOO;   
%token <node> QUO;
%token <node> CHA;   
%token <node> NUM;

%type <node> s
%type <node> obj
%type <node> mem
%type <node> pair
%type <node> val
%type <node> str
%type <node> chars
%type <node> array
%type <node> elem

%%

s: obj {
		fprintf(stderr, "BISON> finished parsing.\n");
		bison_tree = $1;}	
	;

obj: LBR RBR {
		// ch = (char*) malloc(sizeof(char)*5);
		// strcpy(ch, "O:{}");
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$$->next = NULL;
		$$->child = $1;
        $1->next = $2;
		}
   | LBR mem RBR {
		// ch = (char*) malloc(sizeof(char)*6);
		// strcpy(ch, "O:{M}");
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$$->next = NULL;
		$$->child = $1;
        $1->next = $2;
        $2->next = $3;
		}
   ;

mem: pair {
		// ch = (char*) malloc(sizeof(char)*4);
		// strcpy(ch, "M:P");
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = MEMBERS;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		}
   | mem COM pair {
		// ch = (char*) malloc(sizeof(char)*6);
		// strcpy(ch, "M:M,P");
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = MEMBERS;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$$->next = NULL;
		$$->child = $1;
        $1->next = $2;
        $2->next = $3;
		}
   ;

pair: str COL val {
		// ch = (char*) malloc(sizeof(char)*6);
		// strcpy(ch, "P:S:V");
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = PAIR;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$$->next = NULL;
		$$->child = $1;
        $1->next = $2;
        $2->next = $3;
		}
    ;

val: str {
		// ch = (char*) malloc(sizeof(char)*4);
		// strcpy(ch, "V:S");
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = VALUE;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		}
   | NUM {
		// ch = (char*) malloc(sizeof(char)*4);
		// strcpy(ch, "V:N");
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = VALUE;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		}
   | array {
		// ch = (char*) malloc(sizeof(char)*4);
		// strcpy(ch, "V:A");
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = VALUE;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		}
   | obj {
		// ch = (char*) malloc(sizeof(char)*4);
		// strcpy(ch, "V:O");
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = VALUE;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		}
   | BOO {
		// ch = (char*) malloc(sizeof(char)*4);
		// strcpy(ch, "V:B");
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = VALUE;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		}
   ;

str: QUO QUO {
		// ch = (char*) malloc(sizeof(char)*5);
		// strcpy(ch, "S:\"\"");
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = STRING;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$$->next = NULL;
		$$->child = $1;
        $1->next = $2;
		}
   | QUO chars QUO {
		// ch = (char*) malloc(sizeof(char)*6);
		// strcpy(ch, "S:\"C\"");
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = STRING;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$$->next = NULL;
		$$->child = $1;
        $1->next = $2;
        $2->next = $3;
		}
   ;

chars: CHA {
		// ch = (char*) malloc(sizeof(char)*4);
		// strcpy(ch, "C:c");
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = CHARS;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		}
     | chars CHA {
		// ch = (char*) malloc(sizeof(char)*5);
		// strcpy(ch, "C:Cc");
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = CHARS;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$$->next = NULL;
		$$->child = $1;
        $1->next = $2;
		}
	 ;

array: LSQ RSQ {
		// ch = (char*) malloc(sizeof(char)*5);
		// strcpy(ch, "A:[]");
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = ARRAY;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$$->next = NULL;
		$$->child = $1;
        $1->next = $2;
		}
     | LSQ elem RSQ {
		// ch = (char*) malloc(sizeof(char)*6);
		// strcpy(ch, "A:[E]");
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = ARRAY;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$$->next = NULL;
		$$->child = $1;
        $1->next = $2;
        $2->next = $3;
		}
	 ;

elem: val {
		// ch = (char*) malloc(sizeof(char)*4);
		// strcpy(ch, "E:V");
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = ELEMENTS;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		}
    | elem COM val {
		// ch = (char*) malloc(sizeof(char)*6);
		// strcpy(ch, "E:E,V");
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = ELEMENTS;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$$->next = NULL;
		$$->child = $1;
        $1->next = $2;
        $2->next = $3;
		}
	;

%%

int yyerror(char *msg)
{
	printf("Error: %s\n", msg);
	return 0;
}

int main(int argc, char **argv)
{
	char *file_name, ch;
	struct timespec timer_s, timer_e;
	double time_nanoseconds;

	/* Get input parameters. */
	file_name = NULL;
	file_name = argv[1];

	clock_gettime(CLOCK_REALTIME, &timer_s);

	yyin = fopen(file_name, "r");
	if (yyin == NULL) {
		fprintf(stderr, "ERROR> could not open input file. Aborting.\n");
		return 1;
	}
	yyparse();
	fclose(yyin);
	clock_gettime(CLOCK_REALTIME, &timer_e);
	time_nanoseconds=compute_time_interval(&timer_s, &timer_e);
	fprintf(stderr, "time: %lf\n",time_nanoseconds);

	dump_tree(bison_tree, 0);
	return 0;
}


%{
#include<stdlib.h>
#include<stdio.h>
#define YYDEBUG 1
#include "syntabs.h" // pour syntaxe abstraite
extern n_prog *n;   // pour syntaxe abstraite
extern FILE *yyin;    // declare dans compilo
extern int yylineno;  // declare dans analyseur lexical
int yylex();          // declare dans analyseur lexical
int yyerror(char *s); // declare ci-dessous
%}

%union{
n_prog *n_prog;
n_instr *n_instr;
n_l_instr *n_l_instr;
n_exp *n_exp;
n_l_exp *n_l_exp;
n_var *n_var;
n_l_dec *n_l_dec;
n_dec *n_dec;
n_appel *n_appel;
char *sval;
double dval;
}

%token SI
%token ENTIER
%token SINON
%token ALORS
%token FAIRE
%token TANTQUE
%token RETOUR
%token <sval> IDENTIF
%token <dval> NOMBRE
%token VIRGULE
%token POINT_VIRGULE
%token PLUS
%token MOINS
%token FOIS
%token DIVISE
%token EGAL
%token INFERIEUR
%token PARENTHESE_OUVRANTE
%token PARENTHESE_FERMANTE
%token ACCOLADE_OUVRANTE
%token ACCOLADE_FERMANTE
%token CROCHET_OUVRANT
%token CROCHET_FERMANT
%token ET
%token OU
%token NON
%token LIRE
%token ECRIRE


%type <n_prog> programme

%type <n_instr> iAffect iSi iTantQue iAppel iRetour inst iBloc sinonOpt iEcrire
%type <n_l_instr> listInst

%type <n_exp> expression expression1 expression2 expression3 expression4 expression5 expression6

%type <n_l_exp> listExpression listExpressionBis

%type <n_var> var
%type <n_l_dec> listDecVarOpt listDecVar listDecVarBis listDecFct listArgOpt
%type <n_dec> decVar decFct 

%type <n_appel> appelFct



//...
//TODO: compléter avec la liste des terminaux

%start programme
%%

programme : listDecVarOpt listDecFct {n = cree_n_prog($1, $2);};
listDecVarOpt : listDecVar POINT_VIRGULE {$$ = $1;}
	| {$$ = NULL;};
listDecVar : decVar listDecVarBis {$$ = cree_n_l_dec($1, $2);}; 
listDecVarBis : VIRGULE decVar listDecVarBis {$$ = cree_n_l_dec($2, $3);}
	| {$$ = NULL;};
decVar : ENTIER IDENTIF {$$ = cree_n_dec_var($2);}
	| ENTIER IDENTIF CROCHET_OUVRANT NOMBRE CROCHET_FERMANT {$$ = cree_n_dec_tab($2, $4);};

listDecFct : decFct listDecFct {$$ = cree_n_l_dec($1, $2);}| decFct {$$ = cree_n_l_dec($1, NULL);};
decFct : IDENTIF PARENTHESE_OUVRANTE listArgOpt PARENTHESE_FERMANTE listDecVarOpt iBloc {$$ = cree_n_dec_fonc($1, $3, $5, $6);};
listArgOpt : listDecVar {$$ = $1;}
	| {$$ = NULL;};
iBloc : ACCOLADE_OUVRANTE listInst ACCOLADE_FERMANTE {$$ = cree_n_instr_bloc($2);};


listInst : inst listInst {$$ = cree_n_l_instr($1, $2);}
	| {$$ = NULL;};
inst : iAffect {$$ = $1;}
	| iSi {$$ = $1;}
	| iTantQue {$$ = $1;}
	| iAppel {$$ = $1;}
	| iRetour {$$ = $1;}
	| iEcrire {$$ = $1;};

 
iAffect : var EGAL expression POINT_VIRGULE {$$ = cree_n_instr_affect($1, $3);};
iSi : SI expression ALORS iBloc sinonOpt {$$ = cree_n_instr_si($2, $4, $5);};
sinonOpt : SINON iBloc {$$ = $2;}
	| {$$ = NULL;};
iTantQue : TANTQUE expression FAIRE iBloc {$$ = cree_n_instr_tantque($2, $4);};
iAppel : appelFct POINT_VIRGULE {$$ = cree_n_instr_appel($1);};
iRetour : RETOUR expression POINT_VIRGULE {$$ = cree_n_instr_retour($2);};
iEcrire : ECRIRE PARENTHESE_OUVRANTE expression PARENTHESE_FERMANTE POINT_VIRGULE {$$ = cree_n_instr_ecrire($3);};
appelFct : IDENTIF PARENTHESE_OUVRANTE listExpression PARENTHESE_FERMANTE {$$ = cree_n_appel($1, $3);};


listExpression : expression listExpressionBis {$$ = cree_n_l_exp($1, $2);}
	| {$$ = NULL;};
listExpressionBis : VIRGULE expression listExpressionBis {$$ = cree_n_l_exp($2, $3);}
	| {$$ = NULL;};


expression : expression OU expression1 {$$ = cree_n_exp_op(ou, $1, $3);}
	| expression1 {$$ = $1;};
expression1 : expression1 ET expression2 {$$ = cree_n_exp_op(et, $1, $3);}
	| expression2 {$$ = $1;};
expression2 : expression2 EGAL expression3 {$$ = cree_n_exp_op(egal, $1, $3);}
	| expression2 INFERIEUR expression3 {$$ = cree_n_exp_op(inferieur, $1, $3);}
	| expression3 {$$ = $1;};
expression3 : expression3 PLUS expression4 {$$ = cree_n_exp_op(plus, $1, $3);}
	| expression3 MOINS expression4 {$$ = cree_n_exp_op(moins, $1, $3);}
	| expression4 {$$ = $1;};
expression4 : expression4 FOIS expression5 {$$ = cree_n_exp_op(fois, $1, $3);}
	| expression4 DIVISE expression5 {$$ = cree_n_exp_op(divise, $1, $3);}
	| expression5 {$$ = $1;};
expression5 : NON expression5 {$$ = cree_n_exp_op(non, $2, NULL);}
	| expression6 {$$ = $1;};
expression6 : PARENTHESE_OUVRANTE expression PARENTHESE_FERMANTE {$$ = ($2);}
	| var {$$ = cree_n_exp_var($1);}
	| NOMBRE {$$ = cree_n_exp_entier($1);}
	| appelFct {$$ = cree_n_exp_appel($1);}
	| LIRE PARENTHESE_OUVRANTE PARENTHESE_FERMANTE {$$ = cree_n_exp_lire();};


var : IDENTIF {$$ = cree_n_var_simple($1);}
	| IDENTIF CROCHET_OUVRANT expression CROCHET_FERMANT {$$ = cree_n_var_indicee($1, $3);};

//TODO: compléter avec les productions de la grammaire

%%
int yyerror(char *s) {
  fprintf(stderr, "erreur de syntaxe ligne %d\n", yylineno);
  fprintf(stderr, "%s\n", s);
  fclose(yyin);
  exit(1);
}

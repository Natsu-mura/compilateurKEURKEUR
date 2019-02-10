%{
#include<stdlib.h>
#include<stdio.h>
#define YYDEBUG 1
//#include"syntabs.h" // pour syntaxe abstraite
//extern n_prog *n;   // pour syntaxe abstraite
extern FILE *yyin;    // declare dans compilo
extern int yylineno;  // declare dans analyseur lexical
int yylex();          // declare dans analyseur lexical
int yyerror(char *s); // declare ci-dessous
%}

%token SI
%token ENTIER
%token SINON
%token ALORS
%token FAIRE
%token TANTQUE
%token RETOUR
%token IDENTIF
%token NOMBRE
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

//...
//TODO: compléter avec la liste des terminaux

%start programme
%%

programme : listDecVarOpt listDecFct ;
listDecVarOpt : | listDecVar POINT_VIRGULE ;
listDecVar : decVar listDecVarBis ;
listDecVarBis : VIRGULE decVar listDecVarBis | ;
decVar : type IDENTIF tailleOpt ;
tailleOpt : | taille ;
taille : CROCHET_OUVRANT expression CROCHET_FERMANT ;
type : ENTIER ;
listDecFct : decFct listDecFct | decFct ;
decFct : IDENTIF PARENTHESE_OUVRANTE listArgOpt PARENTHESE_FERMANTE listDecVarOpt iBloc ;
listArgOpt : | listDecVar ;
iBloc : ACCOLADE_OUVRANTE listInst ACCOLADE_FERMANTE ;
listInst : inst listInst | ;
inst : iAffect | iSi | iTantQue | iAppel | iRetour ; 
iAffect : var EGAL expression POINT_VIRGULE ;
iSi : SI expression ALORS iBloc sinonOpt ;
sinonOpt : | SINON iBloc ;
iTantQue : TANTQUE expression FAIRE iBloc ;
iAppel : appelFct POINT_VIRGULE;
iRetour : RETOUR expression POINT_VIRGULE ;
appelFct : IDENTIF PARENTHESE_OUVRANTE listExpression PARENTHESE_FERMANTE;
listExpression : | expression listExpressionBis ;
listExpressionBis : VIRGULE expression listExpressionBis | ;
expression : expression OU expression1 | expression1 ;
expression1 : expression1 ET expression2 | expression2 ;
expression2 :expression2 EGAL expression3 | expression2 INFERIEUR expression3 | expression3 ;
expression3 : expression3 PLUS expression4 | expression3 MOINS expression4 | expression4 ;
expression4 : expression4 FOIS expression5 | expression4 DIVISE expression5 | expression5 ;
expression5 : NON expression5 | expression6 ;
expression6 : PARENTHESE_OUVRANTE expression6 PARENTHESE_FERMANTE | var | NOMBRE | appelFct ;
var : IDENTIF | IDENTIF CROCHET_OUVRANT expression CROCHET_FERMANT | appelFct;

//TODO: compléter avec les productions de la grammaire

%%

int yyerror(char *s) {
  fprintf(stderr, "erreur de syntaxe ligne %d\n", yylineno);
  fprintf(stderr, "%s\n", s);
  fclose(yyin);
  exit(1);
}

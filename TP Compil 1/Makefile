CC = gcc
FLEX = flex

LIBS = -lm 
CCFLAGS = -Wall -ggdb

YACC = bison -d -t

OBJ = analyseur_lexical_flex.o util.o analyseur_syntaxique.tab.o syntabs.o  affiche_arbre_abstrait.o parcours_arbre_abstrait.o tabsymboles.o  

all: compilo

compilo: compilo.c $(OBJ)
	$(CC) $(CCFLAGS) -o compilo compilo.c $(OBJ)

analyseur_syntaxique.tab.c: analyseur_syntaxique.y
	$(YACC) analyseur_syntaxique.y

analyseur_lexical_flex.c: analyseur_lexical.flex analyseur_syntaxique.tab.c syntabs.h
	$(FLEX) -o $@ $<	



%.o: %.c
	$(CC) $(CCFLAGS) -c $^

.PHONY : clean

clean:
	- rm -f $(OBJ)
	- rm -f compilo
	- rm -f test_yylex
	- rm -f analyseur_lexical_flex.c
	- rm -f analyseur_syntaxique.tab.c
	- rm -f analyseur_syntaxique.tab.h


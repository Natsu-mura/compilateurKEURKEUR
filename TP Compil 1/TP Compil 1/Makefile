LEX = flex
YACC = bison -d -t
CC = gcc

all: compilo

compilo: compilo.c affiche_arbre_abstrait.o parcours_arbre_abstrait.o analyseur_syntaxique.tab.o analyseur_lexical_flex.o syntabs.o util.o
	$(CC) -o $@ $^

analyseur_syntaxique.tab.c: analyseur_syntaxique.y
	$(YACC) $<

analyseur_lexical_flex.c: analyseur_lexical.flex analyseur_syntaxique.tab.c syntabs.h
	$(LEX) -o $@ $<

%.o: %.c
	$(CC) $(CCFLAGS)-c $^

.PHONY : clean

clean:
	- rm -f $(OBJ)
	- rm -f compilo
	- rm -f test_yylex
	- rm -f analyseur_syntaxique.tab.c
	- rm -f analyseur_syntaxique.tab.h
	- rm -f analyseur_lexical_flex.c
	- rm -f *.o

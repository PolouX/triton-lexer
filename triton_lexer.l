%{
#include <stdio.h>
#include <string.h>

/* tabla de simbolos - solo NAME, NUMBER, STRING */
#define MAX_SYM 200

struct sym_entry {
    char name[128];
    char type[16];
    int line;
};

struct sym_entry sym_table[MAX_SYM];
int sym_count = 0;

/* stack de indentacion para manejar INDENT/DEDENT */
int indent_stack[200];
int indent_top = 0;

int line_num = 1;

/* declaraciones adelantadas */
void add_sym(char *lex, char *tipo, int ln);
void handle_indent(int spaces);
void print_sym_table(void);

%}

%option noyywrap

DIGIT       [0-9]
LETTER      [a-zA-Z_]
ALPHANUM    [a-zA-Z0-9_]
INT         {DIGIT}+
FLOAT       {DIGIT}+"."{DIGIT}+
NAME_PAT    {LETTER}{ALPHANUM}*
STRING_DQ   \"([^\"\\\n]|\\.)*\"
STRING_SQ   \'([^\'\\\n]|\\.)*\'
COMMENT     #[^\n]*
SPACES      [ \t]+

%%

{COMMENT}   { /* descarto comentarios, no emito nada */ }

{INT}{LETTER}{ALPHANUM}*  {
    /* identificador invalido: empieza con digito */
    fprintf(stderr, "ERROR linea %d: identificador invalido '%s'\n", line_num, yytext);
}

{FLOAT}  {
    printf("<%s, FLOAT, %d>\n", yytext, line_num);
    add_sym(yytext, "FLOAT", line_num);
}

{INT}  {
    printf("<%s, NUMBER, %d>\n", yytext, line_num);
    add_sym(yytext, "NUMBER", line_num);
}

{STRING_DQ}  {
    printf("<%s, STRING, %d>\n", yytext, line_num);
    add_sym(yytext, "STRING", line_num);
}

{STRING_SQ}  {
    printf("<%s, STRING, %d>\n", yytext, line_num);
    add_sym(yytext, "STRING", line_num);
}

\"[^\"\n]*  {
    /* cadena con comilla doble que no cierra en la misma linea */
    fprintf(stderr, "ERROR linea %d: cadena no terminada\n", line_num);
}

\'[^\'\n]*  {
    /* cadena con comilla simple que no cierra */
    fprintf(stderr, "ERROR linea %d: cadena no terminada\n", line_num);
}

\n  {
    /* aqui manejo la indentacion al inicio de cada nueva linea */
    int spaces = 0;
    int c;

    line_num++;

    /* leo los espacios/tabs al inicio de la nueva linea */
    c = input();
    while (c == ' ' || c == '\t') {
        if (c == '\t')
            spaces += 4; /* trato tab como 4 espacios */
        else
            spaces++;
        c = input();
    }

    /* si la linea esta en blanco, comentario o fin de archivo, no emito NEWLINE */
    if (c == '\n' || c == '#') {
        unput(c);
        if (c == '\n') line_num--;
    } else if (c == 0 || c == EOF) {
        /* fin de archivo, no devuelvo nada */
        printf("<NEWLINE, %d>\n", line_num - 1);
        handle_indent(spaces);
    } else {
        unput(c);
        printf("<NEWLINE, %d>\n", line_num - 1);
        handle_indent(spaces);
    }
}

{SPACES}  { /* espacios en medio de linea, los descarto */ }

{NAME_PAT}  {
    /* aqui verifico si es keyword o identificador */
    if (strcmp(yytext, "def") == 0)          printf("<DEF, %d>\n", line_num);
    else if (strcmp(yytext, "return") == 0)  printf("<RETURN, %d>\n", line_num);
    else if (strcmp(yytext, "if") == 0)      printf("<IF, %d>\n", line_num);
    else if (strcmp(yytext, "else") == 0)    printf("<ELSE, %d>\n", line_num);
    else if (strcmp(yytext, "elif") == 0)    printf("<ELIF, %d>\n", line_num);
    else if (strcmp(yytext, "for") == 0)     printf("<FOR, %d>\n", line_num);
    else if (strcmp(yytext, "while") == 0)   printf("<WHILE, %d>\n", line_num);
    else if (strcmp(yytext, "in") == 0)      printf("<IN, %d>\n", line_num);
    else if (strcmp(yytext, "is") == 0)      printf("<IS, %d>\n", line_num);
    else if (strcmp(yytext, "and") == 0)     printf("<AND, %d>\n", line_num);
    else if (strcmp(yytext, "or") == 0)      printf("<OR, %d>\n", line_num);
    else if (strcmp(yytext, "not") == 0)     printf("<NOT, %d>\n", line_num);
    else if (strcmp(yytext, "True") == 0)    printf("<TRUE, %d>\n", line_num);
    else if (strcmp(yytext, "False") == 0)   printf("<FALSE, %d>\n", line_num);
    else if (strcmp(yytext, "None") == 0)    printf("<NONE, %d>\n", line_num);
    else if (strcmp(yytext, "pass") == 0)    printf("<PASS, %d>\n", line_num);
    else if (strcmp(yytext, "break") == 0)   printf("<BREAK, %d>\n", line_num);
    else if (strcmp(yytext, "continue") == 0) printf("<CONTINUE, %d>\n", line_num);
    else {
        printf("<%s, NAME, %d>\n", yytext, line_num);
        add_sym(yytext, "NAME", line_num);
    }
}

"**"   { printf("<POWER, %d>\n", line_num); }
"//"   { printf("<FLOORDIV, %d>\n", line_num); }
"<="   { printf("<LE, %d>\n", line_num); }
">="   { printf("<GE, %d>\n", line_num); }
"=="   { printf("<EQ, %d>\n", line_num); }
"!="   { printf("<NE, %d>\n", line_num); }
"+="   { printf("<PLUSEQ, %d>\n", line_num); }
"-="   { printf("<MINUSEQ, %d>\n", line_num); }
"*="   { printf("<TIMESEQ, %d>\n", line_num); }
"/="   { printf("<DIVEQ, %d>\n", line_num); }
"->"   { printf("<ARROW, %d>\n", line_num); }
"<<"   { printf("<LSHIFT, %d>\n", line_num); }
">>"   { printf("<RSHIFT, %d>\n", line_num); }

"+"    { printf("<PLUS, %d>\n", line_num); }
"-"    { printf("<MINUS, %d>\n", line_num); }
"*"    { printf("<TIMES, %d>\n", line_num); }
"/"    { printf("<DIVIDE, %d>\n", line_num); }
"%"    { printf("<MOD, %d>\n", line_num); }
"<"    { printf("<LT, %d>\n", line_num); }
">"    { printf("<GT, %d>\n", line_num); }
"="    { printf("<ASSIGN, %d>\n", line_num); }

"("    { printf("<LPAREN, %d>\n", line_num); }
")"    { printf("<RPAREN, %d>\n", line_num); }
"["    { printf("<LBRACKET, %d>\n", line_num); }
"]"    { printf("<RBRACKET, %d>\n", line_num); }
"{"    { printf("<LBRACE, %d>\n", line_num); }
"}"    { printf("<RBRACE, %d>\n", line_num); }
","    { printf("<COMMA, %d>\n", line_num); }
":"    { printf("<COLON, %d>\n", line_num); }
"."    { printf("<DOT, %d>\n", line_num); }
"@"    { printf("<AT, %d>\n", line_num); }
"~"    { printf("<TILDE, %d>\n", line_num); }
"&"    { printf("<AMPERSAND, %d>\n", line_num); }
"|"    { printf("<PIPE, %d>\n", line_num); }
"^"    { printf("<CARET, %d>\n", line_num); }

\r  { /* ignoro \r de archivos Windows (CRLF) */ }

.  {
    /* cualquier caracter no reconocido */
    fprintf(stderr, "ERROR linea %d: caracter invalido '%s'\n", line_num, yytext);
}

%%

/* agrega un simbolo a la tabla, evita duplicados */
void add_sym(char *lex, char *tipo, int ln) {
    int i;
    /* busqueda lineal para no repetir el mismo lexema */
    for (i = 0; i < sym_count; i++) {
        if (strcmp(sym_table[i].name, lex) == 0)
            return;
    }
    if (sym_count >= MAX_SYM) {
        fprintf(stderr, "ERROR: tabla de simbolos llena\n");
        return;
    }
    strncpy(sym_table[sym_count].name, lex, 127);
    sym_table[sym_count].name[127] = '\0';
    strncpy(sym_table[sym_count].type, tipo, 15);
    sym_table[sym_count].type[15] = '\0';
    sym_table[sym_count].line = ln;
    sym_count++;
}

/* maneja los cambios de nivel de indentacion */
void handle_indent(int spaces) {
    if (spaces > indent_stack[indent_top]) {
        indent_top++;
        indent_stack[indent_top] = spaces;
        printf("<INDENT, %d>\n", line_num);
    } else {
        while (spaces < indent_stack[indent_top]) {
            indent_top--;
            printf("<DEDENT, %d>\n", line_num);
        }
        /* si despues del while no coincide exactamente, es error de indentacion */
        if (spaces != indent_stack[indent_top]) {
            fprintf(stderr, "ERROR linea %d: indentacion inconsistente\n", line_num);
        }
    }
}

void print_sym_table(void) {
    int i;
    printf("\n--- TABLA DE SIMBOLOS ---\n");
    printf("%-5s %-30s %-10s %s\n", "ID", "NOMBRE", "TIPO", "LINEA");
    printf("%-5s %-30s %-10s %s\n", "---", "------------------------------", "----------", "-----");
    for (i = 0; i < sym_count; i++) {
        printf("%-5d %-30s %-10s %d\n", i + 1, sym_table[i].name, sym_table[i].type, sym_table[i].line);
    }
}

int main(int argc, char *argv[]) {
    indent_stack[0] = 0;
    indent_top = 0;

    if (argc > 1) {
        yyin = fopen(argv[1], "r");
        if (!yyin) {
            fprintf(stderr, "ERROR: no se pudo abrir el archivo '%s'\n", argv[1]);
            return 1;
        }
    }

    yylex();

    /* al terminar el archivo, emito DEDENTs pendientes */
    while (indent_top > 0) {
        indent_top--;
        printf("<DEDENT, %d>\n", line_num);
    }

    print_sym_table();

    if (argc > 1)
        fclose(yyin);

    return 0;
}

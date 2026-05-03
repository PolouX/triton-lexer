# Explicacion del Analizador Lexico — triton_lexer.l

Este documento explica el codigo del archivo `triton_lexer.l` para que lo puedas
entender y defender en un examen oral. Lo escribi de la forma mas clara posible,
yendo seccion por seccion del archivo.

---

## 1. Estructura general de un archivo .l

Un archivo `.l` tiene tres secciones separadas por `%%`:

```
%{ codigo C %}        <- declaraciones, includes, variables globales
definiciones nombradas
%%
reglas: patron { accion }
%%
funciones C del usuario
```

Cuando ejecutas `flex triton_lexer.l`, flex lee ese archivo y genera `lex.yy.c`,
un archivo C que contiene una funcion `yylex()`. Esa funcion implementa un automata
finito determinista (DFD) que lee caracteres uno a uno y cuando reconoce un patron,
ejecuta la accion asociada. Despues compilas `lex.yy.c` con gcc y obtienes el
ejecutable final.

---

## 2. Bloque de declaraciones `%{ ... %}`

```c
#include <stdio.h>
#include <string.h>

#define MAX_SYM 200

struct sym_entry {
    char name[128];
    char type[16];
    int line;
};

struct sym_entry sym_table[MAX_SYM];
int sym_count = 0;

int indent_stack[200];
int indent_top = 0;
int line_num = 1;
```

**La tabla de simbolos** es un arreglo de structs. Cada entrada guarda:
- `name[128]`: el lexema (el texto real que aparecio en el fuente, ej: `"x"`, `"3.14"`)
- `type[16]`: el tipo del token (`"NAME"`, `"NUMBER"`, `"FLOAT"`, `"STRING"`)
- `line`: en que linea del archivo fuente aparecio por primera vez

Solo van a la tabla los tokens NAME, NUMBER, FLOAT y STRING. Los keywords NO van
porque son vocabulario fijo del lenguaje — el parser los reconoce directamente sin
necesidad de buscarlos en una tabla.

**El stack de indentacion** es necesario porque Python permite bloques anidados a
cualquier profundidad. Un simple contador no alcanzaria porque cuando cierras un
bloque necesitas saber a que nivel anterior regresar. El stack guarda el historial
de niveles de indentacion activos.

`line_num` lo mantengo yo manualmente porque flex no lo hace automaticamente.

---

## 3. Definiciones nombradas

```
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
```

Estas son como macros — las uso dentro de las reglas con `{NOMBRE}` para no
repetir la regex completa.

- `DIGIT` es una clase de caracteres del 0 al 9.
- `INT` es uno o mas digitos: `{DIGIT}+`
- `FLOAT` es digitos, un punto literal, mas digitos. El punto va entre comillas
  (`"."`) porque sin comillas en regex el punto significa "cualquier caracter".
- `NAME_PAT` empieza con letra o underscore, seguido de cero o mas alfanumericos
  o underscores. Esto corresponde exactamente a la regla de identificadores de Python.
- `STRING_DQ` para cadenas con comilla doble: `\"` abre, luego acepta cualquier
  caracter que NO sea comilla doble, backslash o newline (`[^\"\\\n]`), OR una
  secuencia de escape (`\\.`), y cierra con `\"`. La barra invertida doble `\\`
  en la regex representa un backslash literal.
- `COMMENT` es un `#` seguido de todo hasta el final de linea (pero sin incluir el `\n`).

---

## 4. Reglas — orden critico

El orden de las reglas importa en flex. Cuando dos reglas pueden reconocer el mismo
texto, flex aplica estas dos reglas de prioridad en orden:

1. **Longest match**: gana la regla que consume mas caracteres.
2. **Primera regla**: si empatan en longitud, gana la que aparece primero.

Por eso el orden que use es:

### Regla 1: Comentarios
```
{COMMENT}   { /* descarto */ }
```
Los descarto sin emitir nada. Van primero para que no confundan otras reglas.

### Regla 2: Identificador invalido
```
{INT}{LETTER}{ALPHANUM}*  { fprintf(stderr, "ERROR..."); }
```
Esta regla va ANTES de INT y FLOAT. Si no estuviera, `2bad` se tokenizaria como
`2` (NUMBER) + `bad` (NAME), que es incorrecto. Con esta regla, `2bad` se reconoce
como un solo token invalido.

### Reglas 3 y 4: FLOAT antes que INT
```
{FLOAT}  { ... }
{INT}    { ... }
```
Si INT fuera primero, `3.14` se tokenizaria como `3` (INT) porque flex encontraria
un match con INT y se detendria. Al poner FLOAT primero, flex intenta primero el
patron mas largo y reconoce `3.14` completo como FLOAT.

### Reglas 5-8: Cadenas validas e invalidas
Primero van las cadenas validas (`STRING_DQ`, `STRING_SQ`) y despues las invalidas
(cadena sin cerrar). Si pusiera las invalidas primero, longest-match siempre
preferiria la valida de todas formas, pero el orden explicito es mas claro.

### Regla 9: NEWLINE con logica de indentacion
```c
\n  {
    int spaces = 0;
    int c;
    line_num++;
    c = input();
    while (c == ' ' || c == '\t') {
        spaces += (c == '\t') ? 4 : 1;
        c = input();
    }
    if (c == '\n' || c == '#') {
        unput(c);
        if (c == '\n') line_num--;
    } else if (c == 0 || c == EOF) {
        printf("<NEWLINE, %d>\n", line_num - 1);
        handle_indent(spaces);
    } else {
        unput(c);
        printf("<NEWLINE, %d>\n", line_num - 1);
        handle_indent(spaces);
    }
}
```

Esta es la regla mas compleja. Cuando flex reconoce un `\n`, yo necesito saber
cuantos espacios tiene la proxima linea para decidir si emitir INDENT o DEDENT.
El problema es que flex ya consumio el `\n` y el siguiente caracter esta en el
buffer pero no fue leido aun.

Uso `input()` para leer caracteres adicionales del buffer manualmente. Cuento
los espacios y cuando encuentro un caracter que no es espacio ni tab, lo devuelvo
al buffer con `unput(c)`. Esto es necesario porque si no lo devuelvo, ese caracter
se perderia.

Si la linea siguiente esta en blanco (el caracter es otro `\n`) o es un comentario,
no emito NEWLINE ni llamo a handle_indent — las lineas en blanco no tienen efecto
en Python. Si la linea tiene contenido, emito NEWLINE y llamo a `handle_indent`.

El caso `c == 0 || c == EOF` maneja el fin de archivo: no hago `unput` porque no
hay nada que devolver.

### Regla 10: Espacios en medio de linea
```
{SPACES}  { /* descarto */ }
```
Los espacios entre tokens se descartan. Esta regla va despues de NEWLINE porque
si fuera antes, NEWLINE nunca se dispararia (el espacio al inicio de linea seria
consumido por esta regla antes de que llegue el `\n`). En realidad no — el `\n`
va antes del espacio, entonces el orden aqui no es critico, pero es buena practica.

### Regla 11: NAME y Keywords
```c
{NAME_PAT}  {
    if (strcmp(yytext, "def") == 0)   printf("<DEF, %d>\n", line_num);
    else if ...
    else {
        printf("<%s, NAME, %d>\n", yytext, line_num);
        add_sym(yytext, "NAME", line_num);
    }
}
```

Los keywords NO tienen reglas separadas en flex. La razon: si pusiera una regla
`"in"  { printf("<IN>"); }` y otra `{NAME_PAT}  { ... }`, para la palabra `index`
flex elegiria longest match y usaria NAME_PAT (4 caracteres > 2 de `in`). Pero
para la palabra `in` sola, las dos reglas empatan en longitud (2 caracteres), y
gana la que aparece primero. Si NAME_PAT apareciera primero, `in` se tokenizaria
como NAME. Para evitar este tipo de conflictos, es mas limpio y seguro reconocer
el patron general NAME_PAT y luego dentro de la accion verificar si es keyword.

`yytext` es la variable global de flex que contiene el texto reconocido por la
regla actual. `yyleng` seria la longitud de ese texto.

### Reglas 12-14: Operadores
Los operadores multi-caracter van antes que los de un caracter:
```
"**"  antes que  "*"
"//"  antes que  "/"
"<="  antes que  "<"
```
Por longest match, si estuviera `"*"` antes que `"**"`, cuando flex vea `**`
tomaria solo el primer `*` y emitia TIMES, luego el segundo `*` y emitia TIMES
de nuevo. Al poner `"**"` primero, flex consume los dos caracteres de una vez.

### Regla 15: Catch-all
```
.  { fprintf(stderr, "ERROR linea %d: caracter invalido\n", line_num); }
```
El `.` en flex reconoce cualquier caracter excepto `\n`. Va al final para que
cualquier cosa que no haya reconocido ninguna otra regla caiga aqui.

---

## 5. Funciones de usuario

### `add_sym`
```c
void add_sym(char *lex, char *tipo, int ln) {
    int i;
    for (i = 0; i < sym_count; i++)
        if (strcmp(sym_table[i].name, lex) == 0)
            return;
    if (sym_count >= MAX_SYM) { /* error */ return; }
    strncpy(sym_table[sym_count].name, lex, 127);
    sym_table[sym_count].name[127] = '\0';
    ...
    sym_count++;
}
```

Hace busqueda lineal para no agregar el mismo lexema dos veces. Por ejemplo,
la variable `x` puede aparecer en 10 lineas distintas, pero en la tabla de simbolos
solo aparece una vez (la primera vez que se vio). Uso `strncpy` con limite de 127
caracteres para evitar desbordamiento de buffer si alguien escribe un identificador
muy largo.

### `handle_indent`
```c
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
        if (spaces != indent_stack[indent_top])
            fprintf(stderr, "ERROR linea %d: indentacion inconsistente\n", line_num);
    }
}
```

Ejemplo paso a paso con este codigo:
```python
def foo():      # indent_stack = [0]
    x = 1       # spaces=4 > 0 -> push(4), emit INDENT. stack=[0,4]
    if x:       # spaces=4 == 4 -> nada
        y = 2   # spaces=8 > 4 -> push(8), emit INDENT. stack=[0,4,8]
    z = 3       # spaces=4 < 8 -> pop(8), emit DEDENT. stack=[0,4]. 4==4 OK
```

El `while` es importante: si hay multiples niveles de DEDENT de golpe, emite
un DEDENT por cada nivel que cierra.

### `print_sym_table`
Imprime la tabla al final de la ejecucion con formato de columnas. Itera sobre
`sym_table[0..sym_count-1]`.

### `main`
Inicializa el stack con `indent_stack[0] = 0` (nivel base). Si recibe un argumento
en argv[1], abre ese archivo y lo asigna a `yyin` (variable global de flex que
indica la fuente de entrada). Al terminar `yylex()`, vacia los DEDENTs pendientes
en el stack (cualquier bloque que no se cerro explicitamente en el codigo fuente).

---

## 6. Preguntas frecuentes del profesor

**P: Por que FLOAT va antes que INT en las reglas?**
R: Si INT fuera primero, `3.14` se partia en `3` (INT) y `.14` (error de caracter
invalido). Con FLOAT primero, longest match consume `3.14` completo como un solo token.

**P: Por que los keywords no van en la tabla de simbolos?**
R: Los keywords son parte del lenguaje, no del programa del usuario. La tabla de
simbolos es para los identificadores y literales que el programador definio. El
parser ya sabe de antemano que `if`, `def`, etc. existen — no necesita buscarlos.

**P: Como maneja lex el problema de longest match?**
R: Flex genera un DFA que intenta reconocer el patron mas largo posible antes de
emitir un token. Lee caracteres hasta que ya no puede avanzar en ningun estado
de aceptacion, luego retrocede al ultimo estado de aceptacion valido y emite ese token.

**P: Que pasa si la tabla de simbolos se llena?**
R: `add_sym` verifica `if (sym_count >= MAX_SYM)` y si es verdad imprime un error
en stderr y retorna sin agregar. El lexer sigue funcionando, solo no registra
ese simbolo en la tabla.

**P: Por que usas `unput()` en la regla de NEWLINE?**
R: `input()` lee un caracter del buffer de flex. Cuando encuentro el primer caracter
que no es espacio, ya lo lei y lo "consumi". Si no lo devuelvo, flex nunca lo vera
y ese caracter se pierde. `unput(c)` lo regresa al buffer para que la siguiente
regla lo procese normalmente.

**P: Que hace `yywrap()`?**
R: Es una funcion que flex llama cuando llega al fin de archivo. Si retorna 1,
significa que no hay mas entrada y yylex() termina. Si retorna 0, significa que
hay mas archivos que procesar. Uso `%option noyywrap` para que flex no requiera
que yo defina esta funcion — equivale a que siempre retorne 1.

**P: Por que el error de `2bad` necesita una regla especial?**
R: Sin la regla `{INT}{LETTER}{ALPHANUM}*`, flex tokenizaria `2bad` como dos tokens
separados: `2` (NUMBER) y `bad` (NAME). Eso no es un error — seria silenciosamente
incorrecto. Con la regla especial, `2bad` se reconoce como un unico lexema invalido
y se reporta el error correctamente.

**P: Que son `yytext` y `yyleng`?**
R: Son variables globales que flex define automaticamente. `yytext` es un puntero
al texto que acaba de reconocer la regla actual (es null-terminated). `yyleng` es
la longitud de ese texto. En este lexer uso principalmente `yytext` para imprimir
el lexema y para hacer strcmp en la deteccion de keywords.

**P: Que pasa con los comentarios?**
R: La regla `{COMMENT}` reconoce `#` seguido de cualquier caracter hasta el fin
de linea (sin incluir el `\n`). La accion esta vacia, asi que el comentario se
descarta silenciosamente. El `\n` que sigue al comentario lo maneja la regla NEWLINE
normalmente.

**P: Por que `if`, `else`, `elif` se reconocen en la accion de NAME_PAT y no con
automatas separados como dice Lexer.md?**
R: Lexer.md indica que algunos tokens requieren "automata y tabla de transicion"
para el reporte escrito, pero en la implementacion con flex todos los keywords
se reconocen con el mismo mecanismo: el patron `{NAME_PAT}` los captura y la accion
usa strcmp para clasificarlos. Hacer automatas separados en flex para cada keyword
causaria conflictos de longest match con identificadores que empiezan igual.

---

## 7. Como compilar y ejecutar

```bash
# Generar lex.yy.c
flex triton_lexer.l

# Compilar (en MSYS2/Windows con ucrt64)
export PATH="/c/msys64/ucrt64/bin:/c/msys64/usr/bin:$PATH"
gcc lex.yy.c -o triton_lexer.exe

# Ejecutar con un archivo de prueba
./triton_lexer.exe tests/test_input.py
```

La salida de los tokens va a stdout en formato `<lexema, TOKEN, linea>`.
Los errores van a stderr. La tabla de simbolos se imprime al final en stdout.

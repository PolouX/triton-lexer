# PLAN DE IMPLEMENTACION — Analizador Lexico Triton/Python
> Ultima actualizacion: inicio del proyecto. Marcar cada paso como `[x]` al completarlo y agregar una nota con lo que se hizo.

---

## ENTREGABLES FINALES

| Archivo | Descripcion |
|---|---|
| `triton_lexer.l` | Analizador lexico implementado con flex/lex |
| `explanation.md` | Documento de defensa del codigo (para examen oral) |
| `tests/test_input.py` | Caso de prueba base (de Simbolos_Ejemplo.md) |
| `tests/test_keywords.py` | Prueba de los 17 keywords |
| `tests/test_operators.py` | Prueba de todos los operadores |
| `tests/test_indent.py` | Prueba de INDENT/DEDENT |
| `tests/expected_output.txt` | Salida esperada documentada para todas las pruebas |

---

## FASE 1 — Analisis: Especificacion Formal de Tokens

> Objetivo: definir en papel todos los patrones antes de tocar el archivo .l

### Paso 1.1 — Clasificar los 53 tokens por complejidad
- [ ] **Grupo A — Keywords (17):** def, return, if, else, elif, for, while, in, is, and, or, not, True, False, None, pass, break, continue
  - Se reconocen via strcmp dentro de la accion del patron NAME, NO con reglas separadas
  - Razon: el longest-match de lex haria conflicto entre `in` e `index`
- [ ] **Grupo B — Automatas (6 patrones):** NAME, NUMBER (int/float), STRING, operadores aritmeticos (/, *, +, -), operadores de comparacion (<, >, =, !)
  - Requieren DFA con tabla de transicion para el reporte
- [ ] **Grupo C — Operadores/delimitadores simples (27):** todos los demas simbolos
  - Se reconocen con patrones directos en lex
- [ ] **Grupo D — Indentacion (3):** NEWLINE, INDENT, DEDENT
  - Requieren stack de indentacion en C

> _Nota de completado:_ ___________

---

### Paso 1.2 — Escribir las regex formales (para el archivo .l)

- [ ] Definir los patrones nombrados que iran en la seccion de definiciones del .l:

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

> _Nota de completado:_ ___________

---

### Paso 1.3 — Definir la estructura de la tabla de simbolos

- [ ] Definir la struct `sym_entry` con campos: `name[128]`, `type[16]`, `line`
- [ ] Definir el arreglo `sym_table[200]` y contador `sym_count`
- [ ] Solo van a la tabla: NAME, NUMBER, STRING (los keywords NO)

> _Nota de completado:_ ___________

---

### Paso 1.4 — Asignar IDs numericos a los 59 tokens

- [ ] Asignar IDs del 1 al 59 segun la lista en Lexer.md (DEF=1 ... DEDENT=59)
- [ ] Estos IDs se usaran en la tabla de transicion del reporte escrito

> _Nota de completado:_ ___________

---

## FASE 2 — Diseno: Automatas y Tablas de Transicion

> Objetivo: producir los diagramas y tablas requeridos en el reporte escrito (Seccion 3 del IEEE-830)

### Paso 2.1 — Dibujar DFAs para los tokens del Grupo B

- [ ] **DFA para NAME/Keywords:**
  - S0 -> S1 con LETTER o _
  - S1 (aceptador) -> S1 con LETTER/DIGIT/_; al salir: buscar en tabla de keywords
- [ ] **DFA para NUMBER:**
  - S0 -> S1 con DIGIT; S1 (INT) -> S2 con '.'; S2 -> S3 con DIGIT; S3 (FLOAT)
- [ ] **DFA para STRING:**
  - S0 -> S1 con '"'; S1 -> S2 con '"' (acepta); S1 -> S2 con '\' (escape); error con \n/EOF
  - Mismo esquema para comilla simple
- [ ] **DFA para operadores aritmeticos (/, *, +, -):**
  - `/` -> DIVIDE; `//` -> FLOORDIV; `/=` -> DIVEQ
  - `*` -> TIMES; `**` -> POWER; `*=` -> TIMESEQ
  - `+` -> PLUS; `+=` -> PLUSEQ
  - `-` -> MINUS; `->` -> ARROW; `-=` -> MINUSEQ
- [ ] **DFA para operadores de comparacion (<, >, =, !):**
  - `<` -> LT; `<=` -> LE; `<<` -> LSHIFT
  - `>` -> GT; `>=` -> GE; `>>` -> RSHIFT
  - `=` -> ASSIGN; `==` -> EQ
  - `!` solo -> error; `!=` -> NE

> _Nota de completado:_ ___________

---

### Paso 2.2 — Construir tablas de transicion

- [ ] Una tabla por cada DFA del Paso 2.1 con columnas: Estado | Clase de entrada | Siguiente estado | Token emitido
- [ ] Ejemplo para NUMBER: S0/DIGIT->S1 | S1/DIGIT->S1, S1/'.'->S2, S1/otro->emit INT | S2/DIGIT->S3 | S3/DIGIT->S3, S3/otro->emit FLOAT

> _Nota de completado:_ ___________

---

### Paso 2.3 — Diseno del stack de indentacion (pseudocodigo)

- [ ] Escribir el pseudocodigo de `handle_indent`:

```
indent_stack inicializado en [0], indent_top = 0
al inicio de cada nueva linea:
  contar espacios/tabs -> current_indent
  si current_indent > indent_stack[top]:
    push current_indent
    emitir INDENT
  mientras current_indent < indent_stack[top]:
    pop
    emitir DEDENT
  si current_indent == indent_stack[top]:
    emitir NEWLINE (solo si no es linea en blanco)
```

> _Nota de completado:_ ___________

---

### Paso 2.4 — Diseno de la tabla de simbolos (pseudocodigo)

- [ ] Escribir pseudocodigo de `add_sym` con busqueda lineal y deduplicacion
- [ ] Escribir pseudocodigo de `print_sym_table`

> _Nota de completado:_ ___________

---

## FASE 3 — Implementacion: Escritura del archivo `triton_lexer.l`

> Objetivo: implementar el lexer completo. Trabajar seccion por seccion del archivo .l

### Paso 3.1 — Bloque de declaraciones C `%{ ... %}`

- [ ] Agregar `#include <stdio.h>` y `#include <string.h>`
- [ ] Definir la struct `sym_entry` y el arreglo `sym_table[200]`
- [ ] Definir `indent_stack[200]` e `indent_top = 0`
- [ ] Definir `line_num = 1`
- [ ] Agregar declaraciones adelantadas de: `add_sym`, `handle_indent`, `print_sym_table`

> _Nota de completado:_ ___________

---

### Paso 3.2 — Seccion de definiciones (entre `%}` y primer `%%`)

- [ ] Escribir las 10 definiciones nombradas: DIGIT, LETTER, ALPHANUM, INT, FLOAT, NAME_PAT, STRING_DQ, STRING_SQ, COMMENT, SPACES
- [ ] Agregar `%option noyywrap` para evitar errores de enlace con flex

> _Nota de completado:_ ___________

---

### Paso 3.3 — Seccion de reglas (entre los dos `%%`)

**ORDEN CRITICO: las reglas deben escribirse en este orden exacto**

- [ ] **Regla 1 — Comentarios:** `{COMMENT}` -> descartar silenciosamente
- [ ] **Regla 2 — Identificador invalido:** `{INT}{LETTER}` -> error "no puede iniciar con digito"
  - DEBE ir antes de las reglas INT y FLOAT para tomar prioridad
- [ ] **Regla 3 — FLOAT:** `{FLOAT}` -> imprimir token, agregar a tabla de simbolos
- [ ] **Regla 4 — INT:** `{INT}` -> imprimir token, agregar a tabla de simbolos
- [ ] **Regla 5 — STRING valido DQ:** `{STRING_DQ}` -> imprimir token, agregar a tabla
- [ ] **Regla 6 — STRING valido SQ:** `{STRING_SQ}` -> imprimir token, agregar a tabla
- [ ] **Regla 7 — STRING no terminado DQ:** `\"[^\"\n]*` -> error "cadena no terminada"
- [ ] **Regla 8 — STRING no terminado SQ:** `\'[^\'\n]*` -> error "cadena no terminada"
- [ ] **Regla 9 — NEWLINE con logica de indentacion:**
  - Usar `input()` para leer espacios al inicio de la nueva linea
  - Llamar a `handle_indent(spaces)` con el conteo
  - Usar `unput(c)` para devolver el caracter que no era espacio
  - Imprimir NEWLINE si la linea no esta en blanco
- [ ] **Regla 10 — SPACES:** `{SPACES}` -> descartar (espacios en medio de linea)
- [ ] **Regla 11 — NAME/Keywords:** `{NAME_PAT}` -> if-else con 18 ramas para keywords; si no es keyword, imprimir NAME y agregar a tabla
- [ ] **Regla 12 — Operadores multi-caracter (del mas largo al mas corto):**
  - `**`, `//`, `<=`, `>=`, `==`, `!=`, `+=`, `-=`, `*=`, `/=`, `->`, `<<`, `>>`
- [ ] **Regla 13 — Operadores de un caracter:** `+`, `-`, `*`, `/`, `%`, `<`, `>`, `=`
- [ ] **Regla 14 — Delimitadores:** `(`, `)`, `[`, `]`, `{`, `}`, `,`, `:`, `.`, `@`, `~`, `&`, `|`, `^`
- [ ] **Regla 15 — Catch-all (ULTIMA):** `.` -> error "caracter invalido"

> _Nota de completado:_ ___________

---

### Paso 3.4 — Seccion de codigo C de usuario (despues del segundo `%%`)

- [ ] Implementar `add_sym(char *lex, char *tipo, int ln)`:
  - Busqueda lineal para deduplicacion
  - Verificar que no se desborde `MAX_SYM`
  - Copiar con `strncpy` para evitar desbordamiento de buffer
- [ ] Implementar `handle_indent(int spaces)`:
  - Si `spaces > indent_stack[top]`: push + emitir INDENT
  - Mientras `spaces < indent_stack[top]`: pop + emitir DEDENT
  - Si no coincide despues del while: error de indentacion inconsistente
- [ ] Implementar `print_sym_table()`:
  - Imprimir encabezado con columnas: ID, NOMBRE, TIPO, LINEA
  - Iterar sobre `sym_table[0..sym_count-1]`
- [ ] Implementar `main(int argc, char *argv[])`:
  - Si hay argumento: abrir archivo y asignar a `yyin`
  - Inicializar `indent_stack[0] = 0`
  - Llamar `yylex()`
  - Al terminar: emitir DEDENTs pendientes vaciando el stack
  - Llamar `print_sym_table()`
  - Cerrar archivo si se abrio

> _Nota de completado:_ ___________

---

## FASE 4 — Pruebas

> Objetivo: verificar que el lexer reconoce correctamente todos los tokens y maneja errores

### Paso 4.1 — Crear archivo de prueba base

- [ ] Crear `tests/test_input.py` con el contenido exacto de Simbolos_Ejemplo.md:
```python
x = 10
y = x + 5
msg = ""
z = 3.14
2bad = 7
msg = "hola
w = @
```

> _Nota de completado:_ ___________

---

### Paso 4.2 — Compilar el lexer

- [ ] Ejecutar: `flex triton_lexer.l` -> verificar que genera `lex.yy.c` sin errores
- [ ] Ejecutar: `gcc lex.yy.c -o triton_lexer` (o con `-lfl` si es necesario) -> sin warnings

> _Nota de completado:_ ___________

---

### Paso 4.3 — Verificar salida del caso base

- [ ] Ejecutar: `./triton_lexer tests/test_input.py`
- [ ] Verificar tokens correctos para lineas 1-4 (x, y, msg, z)
- [ ] Verificar error en stderr: `ERROR linea 5: identificador invalido '2bad'`
- [ ] Verificar error en stderr: `ERROR linea 6: cadena no terminada`
- [ ] Verificar que `@` produce `<AT>` (es token valido segun la spec)
- [ ] Verificar tabla de simbolos: 10 entradas con tipos y numeros de linea correctos

> _Nota de completado:_ ___________

---

### Paso 4.4 — Crear y verificar pruebas adicionales

- [ ] Crear `tests/test_keywords.py` con los 17 keywords y verificar que cada uno emite su token correcto
- [ ] Crear `tests/test_operators.py` con todos los operadores (incluyendo `**`, `//`, `<<`, `>>`) y verificar tokens
- [ ] Crear `tests/test_indent.py` con bloques anidados y verificar secuencia INDENT/DEDENT correcta
- [ ] Documentar todos los resultados en `tests/expected_output.txt`

> _Nota de completado:_ ___________

---

## FASE 5 — Documentacion: `explanation.md`

> Objetivo: escribir el documento de defensa del codigo. Escribirlo DESPUES de que el .l este completo y probado.

### Paso 5.1 — Seccion 1: Estructura general del archivo .l
- [ ] Explicar las tres secciones: `%{ %}` (codigo C), reglas, funciones de usuario
- [ ] Explicar el flujo: el compilador lex genera lex.yy.c, se compila con gcc

> _Nota de completado:_ ___________

---

### Paso 5.2 — Seccion 2: Bloque de declaraciones
- [ ] Explicar la struct `sym_entry` campo por campo y por que tiene esos campos
- [ ] Explicar el `indent_stack` y por que Python necesita un stack (no un simple contador)
- [ ] Explicar cada definicion nombrada (DIGIT, FLOAT, STRING_DQ, etc.) y su regex

> _Nota de completado:_ ___________

---

### Paso 5.3 — Seccion 3: Reglas importantes
- [ ] Explicar por que los keywords van dentro de la accion de NAME_PAT (no como reglas separadas)
- [ ] Explicar por que FLOAT debe ir antes que INT
- [ ] Explicar por que `{INT}{LETTER}` debe ir antes de INT y FLOAT
- [ ] Explicar el orden de los operadores multi-caracter (longest match primero)
- [ ] Explicar la regla NEWLINE con `input()`/`unput()` para manejar indentacion

> _Nota de completado:_ ___________

---

### Paso 5.4 — Seccion 4: Tabla de simbolos
- [ ] Explicar `add_sym`: busqueda lineal, deduplicacion, por que strncpy
- [ ] Explicar que tokens van y cuales no (keywords excluidos)
- [ ] Explicar por que se guarda el numero de linea

> _Nota de completado:_ ___________

---

### Paso 5.5 — Seccion 5: Manejo de indentacion
- [ ] Explicar el stack paso a paso con un ejemplo concreto (funcion con bloque if)
- [ ] Explicar por que se necesita `unput()` al leer hacia adelante con `input()`
- [ ] Explicar que pasa al final del archivo: vaciar DEDENTs pendientes

> _Nota de completado:_ ___________

---

### Paso 5.6 — Seccion 6: Preguntas frecuentes del profesor
- [ ] Q: Por que float antes que int en las reglas?
- [ ] Q: Por que los keywords no van en la tabla de simbolos?
- [ ] Q: Como maneja lex el problema de longest match?
- [ ] Q: Que pasa si la tabla de simbolos se llena (mas de 200 entradas)?
- [ ] Q: Por que usas `unput()` en la regla de NEWLINE?
- [ ] Q: Que hace `yywrap()`?
- [ ] Q: Por que el error de `2bad` necesita una regla especial?
- [ ] Q: Que son `yytext` y `yyleng`?
- [ ] Q: Que pasa con los comentarios?

> _Nota de completado:_ ___________

---

## DECISIONES DE DISENO CLAVE (para defender en examen oral)

| Decision | Justificacion |
|---|---|
| Keywords dentro de la accion de NAME_PAT | El longest-match de lex haria que `in` compita con `index`; usando la accion se resuelve correctamente |
| FLOAT antes que INT en las reglas | Si INT va primero, `3.14` se parte en `3` (INT) y `.14` (error); FLOAT primero consume todo |
| `{INT}{LETTER}` antes de INT/FLOAT | Para capturar `2bad` como un solo error en lugar de emitir NUMBER + NAME |
| `unput()` en la regla NEWLINE | `input()` lee un caracter de mas para saber donde termina la indentacion; hay que devolverlo |
| Keywords excluidos de la tabla de simbolos | Los keywords son vocabulario fijo del lenguaje; el parser no necesita buscarlos en tiempo de ejecucion |
| Stack para indentacion | Python permite niveles de indentacion arbitrariamente anidados; un contador simple no alcanza |

---

## NOTAS DE PROGRESO

_Agregar aqui notas generales del avance del proyecto:_

- [x] Fase 1 completada — patrones definidos, estructura de tabla de simbolos disenada, IDs asignados
- [ ] Fase 2 completada — DFAs y tablas de transicion (solo en papel/reporte, no bloquea el codigo)
- [x] Fase 3 completada — triton_lexer.l escrito en C:/Users/Polou/OneDrive/Desktop/AL/triton_lexer.l
- [ ] Fase 4 completada — PENDIENTE: compilar y ejecutar pruebas (ver abajo)
- [ ] Fase 5 completada — explanation.md PENDIENTE (escribir despues de compilar)
- [ ] Revision final: todos los 53 tokens verificados, errores manejados correctamente

---

## ESTADO AL REINICIO — LEER ESTO PRIMERO

### Que se hizo en la sesion anterior

1. Se escribio el archivo `triton_lexer.l` completo en la raiz del proyecto.
   - Implementa los 59 tokens segun Lexer.md
   - Maneja INDENT/DEDENT con stack
   - Tabla de simbolos para NAME, NUMBER, STRING (keywords excluidos)
   - Errores: identificador invalido (2bad), cadena no terminada, caracter invalido
   - Usa `%option noyywrap`

2. Se crearon los 4 archivos de prueba en tests/:
   - `tests/test_input.py` — caso base de Simbolos_Ejemplo.md
   - `tests/test_keywords.py` — los 17 keywords + break/continue
   - `tests/test_operators.py` — todos los operadores
   - `tests/test_indent.py` — bloques anidados para probar INDENT/DEDENT

3. NO se pudo compilar porque `flex` y `gcc` no estaban instalados.
   El usuario fue a instalar MSYS2 (reinicio de PC para completar instalacion).

### Que falta hacer (en orden)

**PASO 1 — Verificar que flex y gcc esten disponibles:**
```
flex --version
gcc --version
```
Si no estan, instalar desde terminal MSYS2 UCRT64:
```
pacman -S flex gcc make
```

**PASO 2 — Compilar el lexer (desde la raiz del proyecto):**
```
cd /c/Users/Polou/OneDrive/Desktop/AL
flex triton_lexer.l
gcc lex.yy.c -o triton_lexer
```
Si da error de -lfl: `gcc lex.yy.c -lfl -o triton_lexer`

**PASO 3 — Ejecutar las 4 pruebas y verificar salida:**
```
./triton_lexer tests/test_input.py
./triton_lexer tests/test_keywords.py
./triton_lexer tests/test_operators.py
./triton_lexer tests/test_indent.py
```
Verificar en test_input.py:
- Tokens correctos para x, y, msg, z (lineas 1-4)
- ERROR stderr: "identificador invalido '2bad'" (linea 5)
- ERROR stderr: "cadena no terminada" (linea 6)
- <AT, 7> para el @ (linea 7)
- Tabla de simbolos con ~10 entradas

**PASO 4 — Si hay bugs, corregir triton_lexer.l y recompilar**

Bugs conocidos posibles:
- La logica de NEWLINE con input()/unput() puede tener edge cases al final del archivo
- Si la ultima linea no tiene \n, los DEDENTs finales se emiten igual (en main())

**PASO 5 — Crear tests/expected_output.txt** con la salida real de cada prueba

**PASO 6 — Escribir explanation.md** (el documento de defensa para el examen oral)
Debe cubrir:
- Estructura del archivo .l (3 secciones)
- Cada definicion nombrada y su regex
- Por que keywords van dentro de la accion de NAME_PAT
- Por que FLOAT antes que INT
- Por que {INT}{LETTER} antes de INT/FLOAT
- El stack de indentacion con ejemplo paso a paso
- La tabla de simbolos (add_sym, deduplicacion, strncpy)
- Preguntas frecuentes del profesor (ver Seccion 5.6 del PLAN)

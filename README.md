# Analizador Lexico — Triton/Python (TC3002B Modulo 3)

Scope rapido del proyecto para que el equipo sepa exactamente que hay, que falta, y como probarlo.

---

## Que es esto

Analizador lexico (scanner) para el lenguaje Triton GPU kernel (un DSL basado en Python). Implementado con `flex` (UNIX-lex) en C. Reconoce 59 tokens, maneja INDENT/DEDENT, y construye una tabla de simbolos.

**Entregables:**
- `triton_lexer.l` — el lexer (unico archivo de codigo fuente)
- `explanation.md` — documento de defensa para examen oral (ver abajo)

---

## Estructura del repositorio

```
AL/
  triton_lexer.l          <- codigo fuente del lexer (flex)
  lex.yy.c                <- generado por flex (no editar)
  triton_lexer.exe        <- ejecutable compilado (Windows/MSYS2)
  explanation.md          <- guia de estudio para el examen oral
  PLAN.md                 <- plan de implementacion detallado con estado de avance
  tests/
    test_input.py         <- caso base (de Simbolos_Ejemplo.md)
    test_keywords.py      <- prueba los 17 keywords
    test_operators.py     <- prueba todos los operadores
    test_indent.py        <- prueba INDENT/DEDENT con bloques anidados
    expected_output.txt   <- salida esperada documentada
    Lexer.md              <- especificacion oficial de los 59 tokens
    Simbolos_Ejemplo.md   <- ejemplo de tabla de simbolos y casos validos/invalidos
    Evaluation_Metrics.md <- rubrica de evaluacion completa del profesor
```

---

## Como compilar y ejecutar

Requiere MSYS2 con flex y gcc. Si no los tienes:

```bash
# instalar desde terminal MSYS2 UCRT64
pacman -S flex gcc make
```

Compilar:

```bash
# desde la raiz del proyecto (en terminal MSYS2 UCRT64)
cd /c/Users/Polou/OneDrive/Desktop/AL

flex triton_lexer.l           # genera lex.yy.c
gcc lex.yy.c -o triton_lexer  # compila el ejecutable
# si da error de enlace: gcc lex.yy.c -lfl -o triton_lexer
```

Ejecutar pruebas:

```bash
./triton_lexer tests/test_input.py
./triton_lexer tests/test_keywords.py
./triton_lexer tests/test_operators.py
./triton_lexer tests/test_indent.py
```

Los tokens van a **stdout** en formato `<lexema, TOKEN, linea>`. Los errores van a **stderr**. La tabla de simbolos se imprime al final.

---

## Que revisar — checklist por area

### 1. Tokens reconocidos (peso 80% en la rubrica de software)
Ver `tests/Lexer.md` para la lista completa. Los puntos criticos:

- **Keywords (17):** def, return, if, else, elif, for, while, in, is, and, or, not, True, False, None, pass, break, continue — se reconocen dentro de la accion de `NAME_PAT`, NO con reglas separadas
- **Automatas requeridos por el profesor** (segun Lexer.md, columna "Tipo esperado"):
  - `if/else/elif` — automata y tabla de transicion
  - `while` — automata y tabla de transicion
  - `NAME` (identificadores) — automata y tabla de transicion
  - `NUMBER` (int y float) — automata y tabla de transicion
  - `STRING` — automata y tabla de transicion
  - Operadores `+`, `-`, `*`, `/` — automata y tabla de transicion
- **INDENT/DEDENT/NEWLINE** — logica con stack de indentacion
- **Errores que el scanner debe reportar:**
  - Identificador invalido: `2bad` (inicia con digito)
  - Cadena no terminada: `"hola` sin cerrar
  - Caracter invalido: cualquier simbolo no reconocido

### 2. Tabla de simbolos
Ver `tests/Simbolos_Ejemplo.md`. Solo van a la tabla: **NAME, NUMBER, FLOAT, STRING**. Los keywords NO van. Cada entrada guarda: lexema, tipo, numero de linea. Sin duplicados (deduplicacion por busqueda lineal).

### 3. Reporte escrito (peso 50% de la nota total)
La rubrica esta en `tests/Evaluation_Metrics.md`. Secciones obligatorias del reporte (IEEE-830):

1. Introduccion (resumen + notacion)
2. Analisis — especificacion informal + regex formales para cada token + descripcion de errores
3. Diseno — DFAs, tablas de transicion, pseudocodigo del stack y tabla de simbolos
4. Implementacion — printout completo del .l explicando las 3 secciones
5. Verificacion y Validacion — casos de prueba con capturas de pantalla
6. Referencias (formato IEEE)

**Peso de cada seccion del reporte:**
- Implementacion con lex: 40%
- Analisis: 20%
- Diseno: 20%
- Ortografia: 10%
- Resto: 10%

### 4. Examen oral (multiplicador x100% de la nota)
El profesor puede pedir modificar el codigo en vivo. Preguntas frecuentes y respuestas estan en `explanation.md`, seccion 6.

---

## Que es explanation.md y por que existe

`explanation.md` es el documento de estudio para el examen oral. El examen oral actua como **multiplicador** de la nota total — si no puedes defender el codigo, la nota puede bajar a 0 aunque el software funcione.

El documento cubre:
- **Estructura del archivo .l** — las 3 secciones de flex y como se genera lex.yy.c
- **Cada definicion nombrada** (DIGIT, FLOAT, STRING_DQ, etc.) con su regex explicada
- **Orden critico de las reglas** — por que FLOAT antes que INT, por que `{INT}{LETTER}` antes de ambos, por que los operadores multi-caracter van primero
- **La regla NEWLINE con input()/unput()** — la mas compleja, explicada paso a paso
- **El stack de indentacion** — con ejemplo concreto mostrando como cambia el stack linea a linea
- **La tabla de simbolos** — add_sym, deduplicacion, strncpy, que tokens van y cuales no
- **9 preguntas frecuentes del profesor** con respuestas listas para usar

Es el archivo mas importante para preparar el examen oral. Leerlo completo antes de la sesion de defensa.

---

## Estado actual del proyecto

| Fase | Estado |
|------|--------|
| Especificacion de tokens (Lexer.md) | Completada |
| triton_lexer.l escrito | Completado |
| Archivos de prueba creados | Completado |
| Compilacion verificada | Pendiente — ver PLAN.md seccion "ESTADO AL REINICIO" |
| explanation.md | Completado |
| Reporte escrito (IEEE-830) | Pendiente |

Para ver el estado detallado y los pasos pendientes, leer `PLAN.md`.

---

## Restricciones importantes (no violar)

- NO usar librerias externas ni codigo de internet
- NO usar el modulo `ast` de Python
- NO usar librerias de expresiones regulares (re, regex, etc.)
- El scanner DEBE implementarse con `lex`/`flex`
- El examen oral es individual — cada integrante debe entender cada linea del codigo

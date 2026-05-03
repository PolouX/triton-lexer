# Especificación de Tokens — Analizador Léxico (Python/Triton)

| Categoría            | Token        | Representación / Descripción | Tipo esperado               | Nota                                              |
|----------------------|--------------|------------------------------|-----------------------------|---------------------------------------------------|
| **Keyword**          | DEF          | `def`                        | REGEX                       |                                                   |
| **Keyword**          | RETURN       | `return`                     | REGEX                       |                                                   |
| **Keyword**          | IF           | `if`                         | Autómata y tabla de transición | `if`, `else`, `elif` van juntos en un solo autómata |
| **Keyword**          | ELSE         | `else`                       | Autómata y tabla de transición | `if`, `else`, `elif` van juntos en un solo autómata |
| **Keyword**          | ELIF         | `elif`                       | Autómata y tabla de transición | `if`, `else`, `elif` van juntos en un solo autómata |
| **Keyword**          | FOR          | `for`                        | REGEX                       |                                                   |
| **Keyword**          | WHILE        | `while`                      | Autómata y tabla de transición | While (Expr)                                      |
| **Keyword**          | IN           | `in`                         | REGEX                       |                                                   |
| **Keyword**          | IS           | `is`                         | REGEX                       |                                                   |
| **Keyword**          | AND          | `and`                        | REGEX                       |                                                   |
| **Keyword**          | OR           | `or`                         | REGEX                       |                                                   |
| **Keyword**          | NOT          | `not`                        | REGEX                       |                                                   |
| **Keyword**          | TRUE         | `True`                       | REGEX                       |                                                   |
| **Keyword**          | FALSE        | `False`                      | REGEX                       |                                                   |
| **Keyword**          | NONE         | `None`                       | REGEX                       |                                                   |
| **Keyword**          | PASS         | `pass`                       | REGEX                       |                                                   |
| **Keyword**          | BREAK        | `break`                      | REGEX                       |                                                   |
| **Keyword**          | CONTINUE     | `continue`                   | REGEX                       |                                                   |
| **Identificador/Literal** | NAME    | identificador                | Autómata y tabla de transición |                                                 |
| **Identificador/Literal** | NUMBER  | número                       | Autómata y tabla de transición |                                                 |
| **Identificador/Literal** | STRING  | cadena                       | Autómata y tabla de transición |                                                 |
| **Operador**         | PLUS         | `+`                          | Autómata y tabla de transición | Autómata para exp como `5 + 6 = 10`              |
| **Operador**         | MINUS        | `-`                          | Autómata y tabla de transición | Autómata para exp como `5 - 6 = 10`              |
| **Operador**         | TIMES        | `*`                          | Autómata y tabla de transición | Autómata para exp como `5 * 6 = 10`              |
| **Operador**         | DIVIDE       | `/`                          | Autómata y tabla de transición | Autómata para exp como `5 / 6 = 10`              |
| **Operador**         | FLOORDIV     | `//`                         | Autómata y tabla de transición | Autómata para exp como `5 // 6 = 10`             |
| **Operador**         | MOD          | `%`                          | Autómata y tabla de transición | Autómata para exp como `5 // 6 = 10`             |
| **Operador**         | POWER        | `**`                         | Autómata y tabla de transición | Autómata para exp como `5 // 6 = 10`             |
| **Operador**         | LT           | `<`                          | REGEX                       |                                                   |
| **Operador**         | GT           | `>`                          | REGEX                       |                                                   |
| **Operador**         | LE           | `<=`                         | REGEX                       |                                                   |
| **Operador**         | GE           | `>=`                         | REGEX                       |                                                   |
| **Operador**         | EQ           | `==`                         | REGEX                       |                                                   |
| **Operador**         | NE           | `!=`                         | REGEX                       |                                                   |
| **Operador**         | ASSIGN       | `=`                          | REGEX                       |                                                   |
| **Operador**         | PLUSEQ       | `+=`                         | REGEX                       |                                                   |
| **Operador**         | MINUSEQ      | `-=`                         | REGEX                       |                                                   |
| **Operador**         | TIMESEQ      | `*=`                         | REGEX                       |                                                   |
| **Operador**         | DIVEQ        | `/=`                         | REGEX                       |                                                   |
| **Delimitador**      | LPAREN       | `(`                          | REGEX                       |                                                   |
| **Delimitador**      | RPAREN       | `)`                          | REGEX                       |                                                   |
| **Delimitador**      | LBRACKET     | `[`                          | REGEX                       |                                                   |
| **Delimitador**      | RBRACKET     | `]`                          | REGEX                       |                                                   |
| **Delimitador**      | LBRACE       | `{`                          | REGEX                       |                                                   |
| **Delimitador**      | RBRACE       | `}`                          | REGEX                       |                                                   |
| **Delimitador**      | COMMA        | `,`                          | REGEX                       |                                                   |
| **Delimitador**      | COLON        | `:`                          | REGEX                       |                                                   |
| **Delimitador**      | DOT          | `.`                          | REGEX                       |                                                   |
| **Delimitador**      | AT           | `@`                          | REGEX                       |                                                   |
| **Delimitador**      | ARROW        | `->`                         | REGEX                       |                                                   |
| **Delimitador**      | TILDE        | `~`                          | REGEX                       |                                                   |
| **Delimitador**      | AMPERSAND    | `&`                          | REGEX                       |                                                   |
| **Delimitador**      | PIPE         | `\|`                         | REGEX                       |                                                   |
| **Delimitador**      | CARET        | `^`                          | REGEX                       |                                                   |
| **Delimitador**      | LSHIFT       | `<<`                         | REGEX                       |                                                   |
| **Delimitador**      | RSHIFT       | `>>`                         | REGEX                       |                                                   |
| **Indentación**      | NEWLINE      | salto de línea               | REGEX                       |                                                   |
| **Indentación**      | INDENT       | aumento indentación          | REGEX                       |                                                   |
| **Indentación**      | DEDENT       | reducción indentación        | REGEX                       |                                                   |

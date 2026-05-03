# Tabla de Símbolos — Ejemplo

## Entradas válidas e inválidas

| Token              | Identificador | Valor    | Error                                          |
|--------------------|---------------|----------|------------------------------------------------|
| NAME               | x             | 10       | —                                              |
| NAME               | y             | 15       | —                                              |
| NAME               | msg           | `"hola"` | —                                              |
| NAME               | z             | 3.14     | —                                              |
| NAME               | 2bad          | —        | Identificador inválido: no puede iniciar con dígito |
| STRING (literal)   | `"hola`       | —        | Cadena no terminada: falta `"`                 |
| (desconocido)      | `@`           | —        | Carácter inválido/no reconocido *(solo si no incluyes AT en tokens)* |

## Código fuente de prueba

```python
x = 10
y = x + 5
msg = ""
z = 3.14
2bad = 7
msg = "hola
w = @
```

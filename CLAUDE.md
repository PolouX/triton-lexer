Propósito
Comprender la importancia del análisis léxico en el proceso de traducción de un lenguaje. 

Instrucciones
Desarrolla, el análisis y diseño de un analizador léxico para el lenguaje de python.
Genera la definición del componente del analizador léxico que se empleará en el análisis de similitud de un texto.

Tu código fuente debe compilar sin errores ni warnings y debe ejecutarse correctamente. Piensa en posibles casos de prueba extremos que pueden ser utilizados para probar tu programa. Para realizar tus pruebas, utiliza los archivos que encontrarás en la carpeta  de tests.

Evaluation_Metric.md (Instrucciones especificas de los entregables)
Lexer.md
Simbolos_Ejemplo.md

Formato de entrega: Ambos analizador léxicos.

Tu solución propuesta debe ser correcta y eficiente

---

REGLAS DE IMPLEMENTACIÓN (CRÍTICAS)

1. PROHIBIDO usar cualquier librería open-source, código de internet, o módulos externos no desarrollados por el estudiante.
2. PROHIBIDO usar el módulo ast de Python o cualquier librería de expresiones regulares (re, regex, etc.).
3. El scanner DEBE implementarse con la herramienta lex (UNIX-lex / flex).
4. NO usar librerías o APIs nativas del lenguaje para reconocimiento de patrones léxicos.

ESTILO DE CÓDIGO — MUY IMPORTANTE

Todo el código debe escribirse como lo haría un estudiante universitario de forma natural:
- Nombres de variables simples y directos (tok, ch, buf, idx, etc.)
- Comentarios breves y en primera persona o estilo informal ("aquí verifico si...", "esto maneja el caso de...")
- Estructuras simples y directas, sin abstracciones innecesarias ni patrones de diseño sofisticados
- Errores tipográficos menores ocasionales en comentarios (naturales, no forzados)
- Lógica incremental: primero los casos simples, luego los especiales
- Evitar nomenclatura enterprise o de producción (nada de factory, handler, manager, etc.)
- El código debe verse como si fue construido iterativamente, no como un sistema completo y perfecto desde el inicio
- Sin documentación excesiva tipo Javadoc o docstrings muy elaborados
- PROHIBIDO usar emojis en cualquier parte del código, comentarios o archivos de entrega
- PROHIBIDO sobre-comentar el código (no explicar lo obvio, solo lo que realmente necesita aclaración)
- PROHIBIDO hacer over-engineering: la solución siempre debe ser la más simple posible que resuelva el problema, sin capas de abstracción innecesarias, sin generalizar para casos que no existen

ENTREGABLES

1. Analizador léxico implementado con lex
2. explanation.md — archivo que explique todo el código de forma que el estudiante lo pueda entender y defender en un examen oral. Debe cubrir:
   - Qué hace cada sección del archivo lex
   - Por qué se tomaron ciertas decisiones de diseño
   - Cómo funciona cada autómata/regex implementado
   - Cómo funciona la tabla de símbolos
   - Posibles preguntas del profesor y sus respuestas
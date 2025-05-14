- Name: Kavya Pillai
- ID: 22000389

Project Description:

Mini Compiler for a Custom Programming Language Using Flex and Bison

- Objective:
To design and implement a compiler front-end for a simple custom programming language. The compiler supports variable declarations, arithmetic operations, conditional execution, and looping constructs. It uses Flex for lexical analysis and Bison for syntax parsing and intermediate code generation.

- What the Project Does:
Parses source code written in a custom language with syntax similar to high-level programming languages.

- Supports basic constructs:
Variable declaration: var a = 3
Arithmetic expressions: a + b, b - a, a * b, b / a
Conditional statements: if ... else
Loops: loop while condition { ... }
Generates intermediate code using temporary variables (e.g., t1, t2) and labels (e.g., L1, L2).

- Instructions to Run:

  1. Make sure Flex and Bison are installed on your system.

  2. Open a terminal in the project folder.

  3. Run the following commands one by one:

     flex lexer.l  
     bison -d parser.y  
     gcc lex.yy.c parser.tab.c -o compiler  

  4. To run the compiler on your custom program file (e.g., input.txt), use:

     ./compiler < input.txt

  5. The output will show parsing results and intermediate code generation.

     Note:
     - `lexer.l` contains the lexical rules.
     - `parser.y` contains grammar rules and intermediate code logic.
     - `input.txt` should contain your sample custom code.

# Parallel_Lexical_Analysis
Lexical Analysis is done in parallel using the OpenMP library and the lex tool.
To run the code you must have lex tool installed.


Step 1 - Run the lex tool on the lexical.l file
            lex lexical.l


Step 2 - Run the code generated (lex.yy.c) on the input test file which you need to tokenize.

If lex is not installed then I have also attached the lex.yy.c file which you can directly run on the test file.

The default test file is set to small_test_file.c.
If you want to change the test file then change the file name in the lexical.l file at line no 82.

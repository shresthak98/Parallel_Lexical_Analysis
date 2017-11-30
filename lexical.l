%option reentrant

%{
	#include "sys/mman.h"
	#include "fcntl.h"
	#include "stdlib.h"
	#include "sys/stat.h"
	#include "stdio.h"
	#include "omp.h"
	#include "time.h"
%}

alpha [a-zA-Z]
digit [0-9]

%%
[ \t]							;
[ \n]   						{ yylineno = yylineno + 1;}
int								printf("INT ");
float 							printf("FLOAT ");
char 							printf("CHAR ");
void 							printf("VOID ");
double 							printf("DOUBLE ");
for 							printf("FOR ");
while							printf("WHILE ");
if								printf("IF ");
else							printf("ELSE ");
printf  						printf("PRINTF ");
struct 							printf("STRUCT ");
main							printf("MAIN ");
^"#include ".+ 					printf("LIB ");
{digit}+       					printf("NUM ");
{alpha}({alpha}|{digit})* 		printf("ID ");
"<="    						printf("LE ");
">="    						printf("GE ");
"=="    						printf("EQ ");
"!="    						printf("NE ");
">"								printf("GT ");
"<"								printf("LT ");
"."     						printf("DOT ");
"{"|"}"|"("|")"					printf("BR ");
\/\/.* 							;
\/\*(.*\n)*.*\*\/ 				;
.       						;
%%

char **buffers;
size_t n_buffers;
int i;
int ttt;


void setup_buffers(const char *filename)
{
	int i=0;
	char *line=NULL;
	char *temp=NULL;
	size_t len=0;
	ssize_t rd;
	FILE *lineno_fp;
	lineno_fp = fopen(filename,"r");
	buffers = malloc(600000000*sizeof(*buffers)); //max size = 6*10^8 lines
	
	if(lineno_fp==NULL)
	exit(EXIT_FAILURE);

	while((rd = getline(&line,&len,lineno_fp)) != -1)
	{
		temp=(char*)malloc(strlen(line)+2);
		temp=line;
		buffers[i]=malloc(strlen(temp)+2);
		strcpy(buffers[i],temp);
		//printf("b=%s",buffers[i]);
		i++;
	}
	n_buffers=i;
}

int main()
{
	//freopen("token.txt","w",stdout); //if you want to save output in file then uncomment this line and make a file with given name
	setup_buffers("small_test_file.c");  //input file name
	double t = omp_get_wtime();
	double tt = clock();
	#pragma omp parallel for
		for(i=0;i<n_buffers;i++)
		{
			yyscan_t scanner;
			if(yylex_init(&scanner))exit(1);
			YY_BUFFER_STATE buf = yy_scan_string(buffers[i],scanner);
			yylex(scanner);
			yy_delete_buffer(buf,scanner);
			yylex_destroy(scanner);
		}
	tt= clock()-tt;
	tt/=CLOCKS_PER_SEC;
	t = omp_get_wtime() - t;
	printf("\nThe time elasped = %f",t);
	return 0;
}

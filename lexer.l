%option noyywrap


%{
#include <iostream>
#include <conio.h>
#include <vector>
#include <string>
#include <stack>
#include <fstream>
#include <regex>
#include <cstdlib>
#include <windows.h>


 #pragma comment(linker, "/SUBSYSTEM:windows /ENTRY:mainCRTStartup")

using namespace std;
#define YY_DECL extern "C" int yylex()


stack<string> sTags;

class Word
{
public:
string literal;
int literalpositon;
string tag = "";
int tagposition = 0;
};

vector<Word> v;

string outputFilePath;
ofstream outputFile;

int tagPos = 0;

int wordPos = 0;



%}

STAG \<[a-zA-Z0-9]*
CTAG \>
ETAG \<\/
WORD [a-zA-Z0-9]*
AHRF a[ ]href=
URL  \"[^\"]*
IGNORETAG \<.*\/>

%s TAGSTARTED
%s TAGCONTENT
%s ETAGSTARTED
%s AHREFSTARTED

%%
\<script\>(.|\n)*?\<\/script\>	{}

{IGNORETAG}			{ ; }
{STAG}				{ string t = yytext; t+=">"; sTags.push(t); BEGIN(TAGSTARTED);  }
<TAGSTARTED>{AHRF}  { BEGIN(AHREFSTARTED);  }
<AHREFSTARTED>{URL} { BEGIN(TAGSTARTED); }
<TAGSTARTED>{WORD}  { }
<TAGSTARTED>{CTAG}  { BEGIN(TAGCONTENT); }
<TAGCONTENT>{WORD}  { outputFile << yytext << "\t\t\t" << sTags.top() << "\t" << wordPos << " " <<  tagPos << "\n"; wordPos++; }
<TAGCONTENT>{ETAG}  { BEGIN(ETAGSTARTED); wordPos = 0; tagPos++; }
<ETAGSTARTED>{WORD} {  }
<ETAGSTARTED>{CTAG} { if(!sTags.empty()) sTags.pop(); BEGIN(TAGCONTENT); }

%%

int
yyparse (char const *file)
{
  yyin = fopen (file, "r");
  if (!yyin)
    {
      perror ("fopen");
      exit (EXIT_FAILURE);
    }
  /* One token only.  */
  yylex ();
  if (fclose (yyin) != 0)
    {
      perror ("fclose");
      exit (EXIT_FAILURE);
    }
  return 0;
}

int main()
{
	string path = "C:\\linux\\crawled\\";
	string searchPattern = "*.txt";
	string fullSearchPath = path + searchPattern;

	WIN32_FIND_DATA FindData;
	HANDLE hFind;

	hFind = FindFirstFile(fullSearchPath.c_str(), &FindData);

	if (hFind == INVALID_HANDLE_VALUE)
	{
		cout << "Error searching directory\n";
		_getch();
		return -1;
	}

	do
	{
		string filePath = path + FindData.cFileName;
		string outputFilePathDir = "C:\\linux\\parsed\\";

		outputFilePath = outputFilePathDir + FindData.cFileName;
		outputFile.open(outputFilePath.c_str());

		//yyin = fopen(filePath.c_str(), "r");
		//FILE *f = NULL;
		//yyout = f;
		//yylex();

		yyparse(filePath.c_str());

		outputFile.close();

		
	} while (FindNextFile(hFind, &FindData) > 0);

	if (GetLastError() != ERROR_NO_MORE_FILES)
	{
		cout << "Something went wrong during searching\n";
	}

	_getch();
	return 0;
}

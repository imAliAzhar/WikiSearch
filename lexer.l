%option noyywrap


%{
#include <iostream>
#include <conio.h>
#include <vector>
#include <string>
#include <stack>
#include <fstream>
#include <regex>

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

ofstream file("webpage.txt");

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
<TAGCONTENT>{WORD}  { file << yytext << "\t\t\t" << sTags.top() << "\t" << wordPos << " " <<  tagPos << "\n"; wordPos++; }
<TAGCONTENT>{ETAG}  { BEGIN(ETAGSTARTED); wordPos = 0; tagPos++; }
<ETAGSTARTED>{WORD} {  }
<ETAGSTARTED>{CTAG} { if(!sTags.empty()) sTags.pop(); BEGIN(TAGCONTENT); }

%%

int main()
{
	yyin = fopen("text.txt", "r");

	FILE *f = NULL;

	yyout = f;
	yylex();

	//system("cls");
	//std::cout << title;

	cout << endl;

	/*
	for(int i = 0; i < v.size(); i++)
	{
		cout << v[i].literal << "\t\t" << v[i].literalpositon << endl;
	}
	Word temp; temp.literal = yytext; temp.literalpositon = 0;  v.push_back(temp); */
	_getch();
	return 0;

	// file << yytext << endl;

}
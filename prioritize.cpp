#include <windows.h>
#include <iostream>
#include <fstream>
#include <string>
#include <cstdlib>
#include <conio.h>
#include <time.h>
#include <regex>
#include <map>

using namespace std;

class terra
{
public:

	string pageID; int totalPriority;

	terra(string pid, string p)
	{
		pageID = pid;
		totalPriority = 0;
		addPriority(p);
	}

	void addPriority(string p)
	{
		totalPriority += atoi(p.c_str());
	}

};

int main()
{
	string path = "C:\\Users\\Ali\\Desktop\\test\\";  // enter address for your input file
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
		clock_t begin = clock();

		string filePath = path + FindData.cFileName;	// FindData.cFileName is the name of the file along with extension i.e april.txt

		ifstream infile(filePath);					// opens the file

		string opath = "C:\\Users\\Ali\\Desktop\\testdone\\";
		string outpath = opath + FindData.cFileName;
		ofstream outfile(outpath);								// for output

		int a, b;

		map<int, int> m;

		map<int, int> ::iterator it;

		string inp;
		string data;

		if (infile.is_open())
		{
			while (infile >> a >> b)
			{
				if (b == 10)
					b = 300;
				if (b == 5)
					b = 1;
				it = m.find(a);
				if (it != m.end())
				{
					b = b + it->second;
					m.erase(it);
				}
				m.insert(pair<int, int>(a, b));
			}
		}

		infile.close();

		for (it = m.begin(); it != m.end(); it++)
		{
			outfile << it->first << " " << it->second << endl;
			cout << it->first << " " << it->second << endl;
		}

		outfile.close();

	} while (FindNextFile(hFind, &FindData) > 0);

	if (GetLastError() != ERROR_NO_MORE_FILES)
	{
		cout << "Something went wrong during searching\n\a";
	}


	_getch();
	return 0;
}
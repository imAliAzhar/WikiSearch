#include <cppconn/driver.h>
#include <cppconn/exception.h>
#include "mysql_connection.h"
#include <cppconn/resultset.h>
#include <cppconn/statement.h>
#include <cppconn/prepared_statement.h>
#include<vector>
#include<map>
#include<string>

using namespace std;

struct Word
{
	string literal;
	int priority;
};

int main(void)
{
	//inputs from parser
	vector<Word> Words;
	vector<string> Citations;
	string URL;
	int PageID;

	try {
		sql::Driver *driver;
		sql::Connection *con;
		sql::Statement *stmt;
		sql::ResultSet *res;
		sql::PreparedStatement *pstmt;

		/* Create a connection */
		driver = get_driver_instance();
		con = driver->connect("tcp://127.0.0.1:3306", "root", "root");
		/* Connect to the MySQL test database */
		con->setSchema("indexer");

		/* Insert URL */
		pstmt = con->prepareStatement("INSERT INTO Pages(URL) VALUES (?)");
		pstmt->setString(1, URL);
		pstmt->executeQuery();
		delete pstmt;

		/* get its page id */
		pstmt = con->prepareStatement("SELECT PageID FROM Pages WHERE URL = ?");
		pstmt->setString(1, URL);
		res = pstmt->executeQuery();
		PageID = res->getInt("pageID");
		delete res;
		delete pstmt;

		/* Insert words to lexicon*/
		for (int i=0 ; i < Words.max_size(); i++)
		{
		LABEL1:
			pstmt = con->prepareStatement("SELECT WordID FROM Lexicon WHERE Word = ?");
			pstmt->setString(1, Words[i].literal);
			res = pstmt->executeQuery();
			int wordID = res->getInt("WordID");
			delete res;
			delete pstmt;
			if (wordID == NULL)
			{
				pstmt = con->prepareStatement("INSERT INTO Lexicon(Word) VALUES (?)");
				pstmt->setString(1, Words[i].literal);
				pstmt->executeQuery();
				delete pstmt;
				goto LABEL1;
			}
			pstmt = con->prepareStatement("INSERT INTO Indexes(PageID,WordID,Position,Priority) VALUES (?,?,?,?)");
			pstmt->setInt(1, PageID);
			pstmt->setInt(2, wordID);
			pstmt->setInt(3, i);
			pstmt->setInt(4, Words[i].priority);
			pstmt->executeQuery();
			delete pstmt;
		}

		/*Insert citations*/
		for (int i = 0; i < Citations.max_size(); i++)
		{
			int citationID;
			pstmt = con->prepareStatement("SELECT PageID FROM Pages WHERE URL = ?");
			pstmt->setString(1, Citations[i]);
			res = pstmt->executeQuery();
			citationID = res->getInt("pageID");
			delete res;
			delete pstmt;
			pstmt = con->prepareStatement("INSERT INTO Citations(PageID,CitationID) VALUES (?,?)");
			pstmt->setInt(1, PageID);
			pstmt->setInt(2, citationID);
			pstmt->executeQuery();
			delete pstmt;
		}

		delete con;
	}
	catch (sql::SQLException &e) {
		cout << "# ERR: SQLException in " << __FILE__;
		cout << "(" << __FUNCTION__ << ") on line " << __LINE__ << endl;
		cout << "# ERR: " << e.what();
		cout << " (MySQL error code: " << e.getErrorCode();
		cout << ", SQLState: " << e.getSQLState() << " )" << endl;
	}

	cout << endl;

	return EXIT_SUCCESS;
}
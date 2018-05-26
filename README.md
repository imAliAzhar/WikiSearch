# Search-Engine-Project
[ Repository made public ]

Hello peeps
We are going to work on our Project on GitHub.
Search-Engine-Project is a private repository. Only those can view/edit who have been granted access.
---

~~Our first milestone is to create a Crawler. I will share resources over here. If you find some too, add them here.~~
Done.

~~Second milestone: Parser~~
Parses a page in O(n) :D
Done.

~~Third milestone: Indexer
Work in progress.~~ Done.

~~Fourth Milestone: Page Rank algorithm.~~ Done.

---

Download GitHub from here
https://desktop.github.com/

If you don't know GitHub yet, look at these tutorials
=> https://www.youtube.com/watch?v=XdhuWDdu-rk
(look for other tutorials if this doesn't make sense or ask me if you have any problem)

Feel free to push(add) any dummy files to practice on this repository. Or create your own and practice there.
There is a tutorial in the installed GitHub application too.

---

CRAWLER =>

	The crawler has been implemented in Python. Given 
a domain, it crawls all the pages without leaving that
domain. It also stores the web page source code along
with the page URL encoded at the top of each txt file.

PARSER =>

	Basically its just a Lexical Analyzer, not a complete
parser. We have used Flex to extract words and certain other data.
For each word, we store the tag in which it occurs, its relative 
position within this tag along with the relative postion of the 
tag itself relative to all other tags. The whole operation operates
at O(n) for each page where n is the number of characters on that
page.
So far, the submitted code only parses a given page. Its 
output for https://simple.wikipedia.org/wiki/April is stored in 
webpage.txt. (Its a temporary arrangment. Once the indexer is
done, this data will be directly stored in MySQL.)

**The .l lexer file DOES NOT ALLOW COMMENTS** 

Moreover, flex needs to be configured for Windows which frankly is
quite a pain.

INDEXER =>

	The output of the parser will be processed by the indexer
which will create a reverse index. 

PRIORITIZE =>

	Sorts pages on the basis of priority for each word.

SEARCH =>

	PHP web page to show results.

<?php

$servername = "localhost";

$username = "root";

$password = "Skeppend,11";

$dbname = "search_engine";

$connection = mysqli_connect($servername, $username, $password, $dbname) or die("Connection Failed!");

function insertURL($pageid, $url)
{
	$conn = $GLOBALS['connection'];

	$sql = "INSERT INTO pages (PageID, URL) VALUES ($pageid, '$url')";
	
	mysqli_query($conn, $sql);
		
}//insertURL()

function insert($pageid, $word, $priority, $position)
{
    $conn = $GLOBALS['connection'];

    $sql = "SELECT MAX(WordID) AS max FROM lexicon";
	
	$result = mysqli_query($conn, $sql);

	$row = mysqli_fetch_array($result);
		
	$wordid = $row['max'] + 1;

	$sql = "INSERT INTO lexicon (WordID,Word) VALUES ($wordid,'$word')";
		
	mysqli_query($conn, $sql);

	$sql = "SELECT WordID FROM lexicon WHERE Word = '$word'";
	
	$result = mysqli_query($conn, $sql);

	$row = mysqli_fetch_array($result);
		
	$wordid = $row["WordID"];

	$sql = "INSERT INTO indexes (PageID,WordID,Priority,Position) VALUES ($pageid,$wordid,$priority,$position)";
	
	mysqli_query($conn, $sql);
	
}//insert()

$count = count(glob("Words/"."*"));

echo "Indexing $count pages <br><br>";

for ($pageid=1; $pageid<=$count; $pageid++)
{

	$file = fopen("Words/".$pageid.".txt","r");
	
	$url = fgets($file);
	
	insertURL($pageid, $url);
	
	$word;
	
	$priority;
	
	$position = 0;
	
	while(!feof($file))
	{
		
		$line = explode(" ",fgets($file));
		
		$position++;
		
		$word = $line[0];
		
		$priority = (int)$line[1];
		
		insert($pageid,$word,$priority,$position);
		
	}

	fclose($file);

	echo "page $pageid has indexed...<br>";

}

mysqli_close($connection);

?>
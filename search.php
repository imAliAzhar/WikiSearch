<?php

function multiexplode ($delimiters,$string) {

    $ready = str_replace($delimiters, $delimiters[0], $string);
    $launch = explode($delimiters[0], $ready);
    return  $launch;
}

$text = explode(" ","April Fool");
$pages;

for($i=0; $i<count($text); $i++)
{
    if(file_exists("rindex/".$text[$i].".txt"))
    {
        $file = fopen("rindex/".$text[$i].".txt","r");
        while(!feof($file))
        {
            $line = explode(" ",fgets($file));
            $pages[$line[0]] = $pages[$line[0]] + $line[1];                       
        }
        fclose($file);
    }
}
//print_r($pages);
//echo "<hr>";
arsort($pages);
//print_r($pages);
/*
foreach ($pages as $key => $row) {
    $w[$key]  = $row[1];
    $p[$key] = $row[2];
}

array_multisort($pages, SORT_DESC, $w, SORT_DESC, $p);

print_r($pages);
*/
foreach($pages as $key => $value)
{  
    $file = fopen("findex/".$key.".txt","r");
    echo fgets($file);
    echo "<hr>";
    fclose($file);
}

?>
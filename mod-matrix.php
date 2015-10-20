#!/usr/bin/env php
<?php
/*
(c) Sebb767, 2015

This little script takes a number and a sign and outputs a corresponding matrix
which keeps numbers between 0 and number-1.

*/


$usage = "Usage: ".$argv[0]." <number> <sign>";

if($argc < 2)
{
    die($usage);
}

$nr = $argv[1];
$sign = $argv[2];

$ops = [
    '+' => function($a, $b) { return $a + $b; },
    '*' => function($a, $b) { return $a * $b; },
    '-' => function($a, $b) { return $a - $b; },
    ];

if(!is_numeric($nr) || !in_array($sign, array_keys($ops))
    )
{
    die($usage);
}

$line = range(0, $nr - 1); // numbers from 0...n-1
$dataset = [0 => array_merge([$sign], $line)]; // our output array

for($i = 0; $i < $nr; $i++) // do the math
{
    $dataset[$i+1][] = $line[$i];
    for($y = 0; $y < $nr; $y++)
    {
        // use the given sign for the operation & take the mod
        $result = $ops[$sign]($y, $i) % $nr;
        if($result < 0) 
            $result += $nr; // php's % is mathematically incorrect :p
        
        $dataset[$i+1][] = $result;
    }
}

// helper from https://stackoverflow.com/questions/1319903/how-to-flatten-a-multidimensional-array
function array_flatten($array) {
    $return = array();
    foreach ($array as $key => $value) {
        if (is_array($value)){
            $return = array_merge($return, array_flatten($value));
        } else {
            $return[$key] = $value;
        }
    }

    return $return;
}


// get the longest string + 1 for space between rows
$maxlen = max(array_map('strlen', array_flatten($dataset))) + 1; 

$nr += 1; // add outer lines for iteration
for($x = 0; $x < $nr; $x++)
{
    for($y = 0; $y < $nr; $y++)
    {
        echo str_pad($dataset[$x][$y], $maxlen);
    }
    echo "\n";
}
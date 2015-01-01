<?php

function read_template($filename)
{
	$source = join("",file($filename));
	if (strlen($source) == 0)
	{
		die("Templatefaili ei õnnestud avada!");
	}
	return $source;
}

function parse_template($source,$vars)
{
	if (is_array($vars))
	{
		foreach($vars as $key => $value)
		{
			$tag = "{VAR:" . $key . "}"; 
			$source = str_replace($tag,$value,$source);
		}
	}
	return $source;
}

?>

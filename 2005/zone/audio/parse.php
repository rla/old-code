<pre>
<?php

$str='c=45;';
echo "command: " .$str ."\n";

define('ASSIGN', 0);
define('ADD', 1);
define('SUBSTRACT', 2);
define('DIV', 3);
define('MULT', 4);
define('POWER', 5);
define('BRACKET_OPEN', 6);
define('BRACKET_CLOSE', 7);
define('FUNCT', 8);
define('COMMA', 9);
define('SEMICOLON', 10);
define('VARCONSTANT', 9999);

$stack=array();
$heap=array();
$mem=array();
$variables=array();

function last($s) { return $s[count($s)-1]; }

function output($com, $c1, $c2) {

	global $mem;
	global $heap;
	
	switch ($com) {
		case MULT: { echo 'MULT ' .$c1 .' ' .$c2 ."\n"; return $mem[$c1]*$mem[$c2]; }
		case ADD: { echo 'ADD ' .$c1 .' ' .$c2 ."\n"; return $mem[$c1]+$mem[$c2]; }
		case DIV: { echo 'DIV ' .$c1 .' ' .$c2 ."\n"; return $c1/$c2; }
		case FUNCT: { echo 'FUNCT ' .$c1 .' ' .$c2 ."\n"; return 0; }
		case ASSIGN: { echo 'ASSIGN ' .$c1 .' ' .$c2 ."\n"; $mem[$c1]=$mem[$c2]; return 0; }
	}
}
function choose($ch) {
	switch ($ch) {
		case '+': return ADD; break;
		case '*': return MULT; break;
		case '/': return DIV; break;
		case '(': return BRACKET_OPEN; break;
		case ')': return BRACKET_CLOSE; break;
		//case ',': return COMMA; break;
		case '=': return ASSIGN;
		case ';': return SEMICOLON;
		default: return VARCONSTANT; break;
	}
}

$ap=0;
function mov($val) {

	global $mem;
	global $ap;
	$ap++;
	$mem[$ap]=$val;
	return $ap; 

}

//Parsimine

//Lexer

$lasttoken=VARCONSTANT;
for ($i=0; $i<strlen($str); $i++) {

	$ch=$str{$i};
	$c=choose($ch);
	if ($c!=VARCONSTANT) {
	
		//semikoolon, lõpetab ühe lause
		if ($c==SEMICOLON) {
		
			echo 'line end';
		
		}
		
		//tegemist funktsiooniga
		if ($c==BRACKET_OPEN && $lasttoken==VARCONSTANT) {
			array_push($stack, BRACKET_OPEN);
			array_push($stack, FUNCT);
			array_push($heap, $buffer);
			$lasttoken=FUNCT;
			$buffer="";
			continue;
		}
		
		if ($buffer) {
			if (is_numeric($buffer)) array_push($heap, mov($buffer));
			else if ($variables['c']) array_push($heap, $variables['c']);
			else { $variables['c']=mov(0); array_push($heap, $variables['c']); }
		}
		
		//tagasiminek avava suluni
		if ($c==BRACKET_CLOSE) {
		
			while (true) {

				$com=array_pop($stack);
				if ($com==BRACKET_OPEN) break;
				array_push($heap, mov(output($com, array_pop($heap), array_pop($heap))));
				
			}
			
			$buffer="";
			$lasttoken=$c;
			continue;
		
		}
		
		if (last($stack)>$c && last($stack)!=BRACKET_OPEN && $c!=BRACKET_CLOSE && last($stack)!=FUNCT)
			array_push($heap, mov(output(array_pop($stack), array_pop($heap), array_pop($heap))));	
			
		array_push($stack, $c);
		
		$buffer="";
		$lasttoken=$c;
		continue;
		
	}
	
	$buffer.=$ch;
	$lasttoken=$c;

}

if ($buffer) {
	if (is_numeric($buffer)) array_push($heap, mov($buffer));
	else if ($variables['c']) array_push($heap, $variables['c']);
	else { $variables['c']=mov($buffer); array_push($heap, $variables['c']); }
}

var_dump($variables);
var_dump($mem);
var_dump($heap);

//Lõpetustehted

while (count($stack)) { array_push($heap, mov(output(array_pop($stack), array_pop($heap), array_pop($heap)))); }

echo 'RESULT: ' .$mem[$heap[0]];

var_dump($variables);
var_dump($mem);

?>
</pre>
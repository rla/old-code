<html>
<head>
<META HTTP-EQUIV="expires" CONTENT="0">
</head>
<body>
<?php

$max_x=400;
$max_y=150;
if ($_GET['amplitude']==''): $amplitude=10; else: $amplitude=$_GET['amplitude']; endif;
if ($_GET['period']==''): $period=70; else: $period=$_GET['period']; endif;
if ($_GET['text']==''): $text='Your text'; else: $text=$_GET['text']; endif;


$im=imagecreatefrompng("text.png");
$iminfo=getimagesize("text.png");
$max_x=$iminfo[0];
$max_y=$iminfo[1];

$white  = imagecolorallocate($im, 255, 255, 255);
$black = imagecolorallocate($im, 0, 0, 0);

/*for($x=0; $x<$max_x; $x++)
  for($y=0; $y<$max_y; $y++) imagesetpixel($im, $x, $y, $white);
*/
//$im2=imagecreate($max_x, $max_y);

imagestring($im, 10, 10, 10, $text, $black);

for($x=0; $x<$max_x; $x++) {
    //caclulate how much to shift pixel
	$shift_y=round($amplitude*sin($x*PI()/$period));

    //clear new_c
    for($y=0; $y<$max_y; $y++) $new_c[$y]=$white;

    for($y=0; $y<$max_y; $y++) {
    	//$new_c=array();
        //get one pixel..
    	$pix=imagecolorat($im, $x, $y);
        //$new_c[$y]=$pix;
        //imagesetpixel($im, $x, $y, $white);

        //$new_y=$y+$shift_y;
        if (($new_y>=0) or ($new_y<$max_y)) $new_c[$y+$shift_y]=$pix;
    }
    //replace pixel column with values from array
    for($y=0; $y<$max_y; $y++) imagesetpixel($im, $x, $y, $new_c[$y]);
}

imagepng($im, "result1.png");

imagedestroy($im);
//imagedestroy($im2);

print '<img src="result1.png" nocache="1"></img>
<form method="get" action="image.php">
Amplitude <input type="text" name="amplitude" value="' .$amplitude . '"><br>
Period <input type="text" name="period" value="' .$period . '"><br>
Your text <input type="text" name="text" value="' .$text . '"><br>
<input type="submit" value="Submit">
</form>';

?>
</body>
</html>
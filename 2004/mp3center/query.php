<html>
  <head>
    <title></title>
    <style>
    .mp3td {
      font-family: tahoma;
      font-size: 10pt;
    }
    </style>
  </head>
  <body>
<?php

function Mp3SearchQuery($bywhat, $search) {
	$found_index=array();
	switch($bywhat) {
    	case 'title':
        	$found=0;
            $i=0;
        	$index=fopen('songs.ind', 'rb');
            while(!feof($index) and $found<100) {
                 fseek($index, $i*50);
                 if (strpos(fread($index, 50), $search)) {
                 	$found++;
                    array_push($found_index, $i);
                 }
                 $i++;
            }
            fclose($index);
        break;
    }

    $table=fopen('mp3.tbl', 'rb');
    print '<table border="0" width="100%" cellspacing="0" bordercolor="#000000">';
    $rowcolor="ffffff";
    $oddr=false;
    foreach($found_index as $value) {
    	print '<tr>';
    	fseek($table, $value*157); //50+50+50+3+4=157
        $title=rtrim(fread($table, 50));
        $artist=rtrim(fread($table, 50));
        $album=rtrim(fread($table, 50));
        $year=fread($table, 4);
        $genre=fread($table, 3);
        switch($bywhat) {
        	case 'title': $title=str_replace($search, '<b>' .$search .'</b>', $title);
        }
        if($oddr) $rowcolor="cccccc";
        else $rowcolor="ffffff";

        $oddr=!($oddr);
        print '
        	<td bgcolor="#' .$rowcolor .'" class="mp3td">' .$artist .'</td>
        	<td bgcolor="#' .$rowcolor .'"><a href="info.php?id=' .$value .'" class="mp3td">' .$title .'</a></td>
            <td bgcolor="#' .$rowcolor .'" class="mp3td">' .$album .'</td>
            <td bgcolor="#' .$rowcolor .'" class="mp3td">' .$year .'</td></tr>' ."\n";
    }
    fclose($table);
    print '</table>';

    return 1;
}

Mp3SearchQuery('title', 'are');

?>
</body></html>
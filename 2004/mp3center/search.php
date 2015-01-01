<?php

function Mp3SearchQuery($bywhat, $search) {
	$found_index=array();
    $found=0;
    $i=0;
    $search=strtoupper($search);
    $do_index_search=false;
	switch($bywhat) {
    	case 'title':
        	$fname='songs.ind';
            $rec_size=50;
            $do_index_search=true;
        break;
        case 'genre':
    		$fname='genres.ind';
            $index=fopen($fname, 'rb');
    		while(!feof($index) and $found<100) {
    			fseek($index, $i*3);
        		if (rtrim(fread($index, 3))==$search) {
        			$found++;
            		array_push($found_index, $i);
        		}
        		$i++;
    		}
    		fclose($index);
        break;
        case 'year':
        	$fname='years.ind';
            $index=fopen($fname, 'rb');
    		while(!feof($index) and $found<100) {
    			fseek($index, $i*4);
        		if (rtrim(fread($index, 4))==$search) {
        			$found++;
            		array_push($found_index, $i);
        		}
        		$i++;
    		}
    		fclose($index);
        break;
        case 'artist':
        	$rec_size=50;
            $fname='artists.ind';
            $do_index_search=true;
        break;
        case 'album':
        	$rec_size=50;
            $fname='albums.ind';
            $do_index_search=true;
        break;
    }
    if($do_index_search) {
    	$index=fopen($fname, 'rb');
    	while(!feof($index) and $found<100) {
    		fseek($index, $i*$rec_size-1);
        	if (strpos( strtoupper( fread($index, $rec_size) ), $search )) {
        		$found++;
            	array_push($found_index, $i);
        	}
        	$i++;
    	}
    	fclose($index);
    }

    $table=fopen('mp3.tbl', 'rb');
    print '<table border="0" width="100%" cellspacing="0" bordercolor="#000000">';
    $rowcolor="ffffff";
    $oddr=false;
    foreach($found_index as $value) {
    	print '<tr>';
    	fseek($table, $value*168); //50+50+50+3+4+4+7=168
        $title=rtrim(fread($table, 50));
        $artist=rtrim(fread($table, 50));
        $album=rtrim(fread($table, 50));
        $year=fread($table, 4);
        $genre=fread($table, 3);
        switch($bywhat) {
        	case 'title':
            	$title=str_replace($search, '<b>' .$search .'</b>', $title);
                if (strlen($search)==1) $title=str_replace(strtoupper($search), '<b>' .strtoupper($search) .'</b>', $title);
            break;
        }
        if($oddr) $rowcolor="eeeeee";
        else $rowcolor="ffffff";

        $oddr=!($oddr);
        print '
        	<td bgcolor="#' .$rowcolor .'" class="textlink">' .$artist .'</td>
        	<td bgcolor="#' .$rowcolor .'"><a href="index.php?action=info&id=' .$value .'" class="textlink">' .$title .'</a></td></tr>' ."\n";
    }
    fclose($table);
    print '</table>';

    return 1;
}

?>
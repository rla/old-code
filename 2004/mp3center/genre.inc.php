<?php

function Mp3DecodeGenre($genre_id) {
	$genres=array(
	'Blues','Classic Rock','Country','Dance','Disco','Funk','Grunge', #6
	'Hip-Hop','Jazz','Metal','New Age','Oldies','Other','Pop','R&B','Rap', #15
	'Reggae','Rock','Techno','Industrial','Alternative','Ska','Death Metal', #22
	'Pranks','Soundtrack','Euro-Techno','Ambient','Trip-Hop','Vocal', #28
	'Jazz+Funk','Fusion','Trance','Classical','Instrumental','Acid','House', #35
	'Game','Sound Clip','Gospel','Noise','AlternRock','Bass','Soul','Punk','Space', #44
	'Mediative','Instrumental Pop','Instrumental Rock','Ethnic','Gothic','Darkwave', #50
	'Techno-Industrial','Electronic','Pop-Folk','Eurodance','Dream','Southern Rock','Comedy','Cult', #58
	'Gangsta','Top 40','Christian Rap','Pop/Funk','Jungle','Native American','Cabaret', #65
	'New Wave','Psychadelic','Rave','Showtunes','Trailer','Lo-Fi','Tribal','Acid Punk', #73
	'Acid Jazz','Polka','Retro','Musical','Rock & Roll','Hard Rock', #79
	'Folk','Folk-Rock','National Folk','Swing','Fast Fusion','Beobob','Latin','Revival','Celtic', #88
	'Bluegrass','Avantgarde','Gothic Rock','Progressive Rock','Psychedelic Rock','Symphonic Rock', #94
	'Slow Rock','Big Band','Chorus','Easy Listening','Acoustic','Humour','Speech','Chanson','Opera', #103
	'Chamber Music','Sonata','Symphony','Booty Brass','Primus','Porn Groove','Satire','Slow Jam', #111
	'Club','Tango','Samba','Folklore','Ballad','Power Ballad','Rhytmic Soul','Freestyle','Duet', #120
	'Punk Rock','Drum Solo','A Capela','Euro-House','Dance Hall');

	if ($genre_id<126) return $genres[$genre_id];
    else return 'Unknown';
}

?>
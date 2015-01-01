	<table border="0" cellspacing="1" bgcolor="#999999" width="120">
	<tr><td bgcolor="#999999" height="20">
	<div class="wintitel" align="center">{VAR:local_title}</div>
	</td></tr>
	<tr><td bgcolor="#eeeeee" height="500" valign="top">
	<p class="text">
	<br>
    {VAR:teade_01}
	{VAR:teade_02}
	{VAR:teade_03}
	</p>
	<hr>
	<p class="text">
	<b>{VAR:poll}</b><br>
	<form action="index.php?mis=poll&keel={VAR:keel}" method="post">
	{VAR:poll_title}<br>
	<input type="radio" name="rb" value="1" checked>{VAR:poll_01}<br>
	<input type="radio" name="rb" value="2">{VAR:poll_02}<br>
	<input type="radio" name="rb" value="3">{VAR:poll_03}<br>
	<input type="radio" name="rb" value="4">{VAR:poll_04}<br>
	<input type="radio" name="rb" value="5">{VAR:poll_05}<br>
	&nbsp; &nbsp;<input type="image" src="graphics/poll_button.gif">
	</form>
	&nbsp; &nbsp; <a href="index.php?mis=poll&keel={VAR:keel}" class="text">{VAR:poll_tulemused}</a>
	</p>
	</td></tr>
	</table>
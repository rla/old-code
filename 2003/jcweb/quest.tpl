<table border="0" cellspacing="1" bgcolor="#999999" width="512">
<tr><td bgcolor="#999999" height="20">
<div class="wintitel" align="left">&nbsp; &nbsp;{VAR:local_title}</div>
</td></tr>
<tr><td bgcolor="#eeeeee" height="500" valign="top">
<p class="text">
<br>
{VAR:pic}{VAR:sisu}<hr><br>
&nbsp; &nbsp;<a href="index.php?mis={VAR:mis}&keel={VAR:keel}&subid=2" class="text">{VAR:in_05}</a><br>
<form action="index.php?mis={VAR:mis}&keel={VAR:keel}" method="post">
<table align="center" border="1" bordercolor="#cccccc" cellpadding="5" cellspacing="0">
<tr><td class="text">{VAR:in_01}<br><input type="text" maxlength="100" name="nimi"></td></tr>
<tr><td class="text">{VAR:in_02}<br><input type="text" maxlength="100" name="mail"></td></tr>
<tr><td class="text">{VAR:in_03}<br><input type="text" maxlength="100" name="weeb"></td></tr>
<tr><td class="text">{VAR:in_04}<br><textarea name="msg" rows="10" cols="40"></textarea></td></tr>
<tr><td class="text"><input type="image" src="graphics/poll_button.gif"></td></tr>
<input type="hidden" name="subid" value="2">
<input type="hidden" name="lisa" value="1">
</table>
</form>
</p>
</td></tr>
</table>
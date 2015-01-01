<script language="JavaScript" type="text/javascript">

document.onmouseover=show_it;
document.onmouseout=hide_it;

//Linkide näitamise skript.
//Vajab objekti, milled id="link_show"!
//Raivo Laanemets 2004

function show_it(evt) {
  self.status = "";
  var src = (typeof evt != 'undefined') ? evt.target : event.srcElement;
  if (src.tagName=="A" && src.className=="vmenu") {
    document.getElementById('link_show').innerHTML=">> " +src.innerHTML;
  }
}

function hide_it(evt) {
  var src = (typeof evt != 'undefined') ? evt.target : event.srcElement;
  if (src.tagName=="A")  {
    document.getElementById('link_show').innerHTML=">> ";
  }
}
</script>
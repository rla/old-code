function stripes() {
	var even = false;
	var table = document.getElementById("data");
	if (! table) { return; }
	var tbodies = table.getElementsByTagName("tbody");
	for (var h = 0; h < tbodies.length; h++) {
		var trs = tbodies[h].getElementsByTagName("tr");
		for (var i = 0; i < trs.length; i++) {
			var tds = trs[i].getElementsByTagName("td");
			for (var j = 0; j < tds.length; j++) {
				var mytd = tds[j];
				mytd.style.backgroundColor = even ? "#ccffcc" : "#ccccff";
			}
			even = !even;
		}
	}
}

function save(formid, url) {
	form = document.getElementById(formid);
	url = url + "?";
	for (i = 0; i < form.elements.length; i++) {
		url = url + form.elements[i].name + "=" + form.elements[i].value + "&";
	}
	content = new XMLHttpRequest();
	content.onreadystatechange = refreshContent;
	content.open("GET", url, true);
	content.send(null);
}

function refreshContent() {
	if (content.readyState != 4 || content.status != 200) { return; }
	div = document.getElementById("content");
	div.innerHTML = content.responseText;
	stripes();
}

function requestContent(url) {
	content = new XMLHttpRequest();
	content.onreadystatechange = refreshContent;
	content.open("GET", url, true);
	content.send(null);
}
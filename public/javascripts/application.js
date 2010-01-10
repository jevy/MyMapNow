$(document).ready(
	function() {
		$("ul.tabs").tabs("div.panes > div");
	}
);

function submitenter(myfield,e) {
	var keycode;
	if (window.event) keycode = window.event.keyCode;
	else if (e) keycode = e.which;
	else return true;

	if (keycode == 13)
	   {
	   Map.search($('#search-box').val());
	   return false;
	   }
	else
	   return true;
}

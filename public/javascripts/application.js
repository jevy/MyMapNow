$(function() {
	var date = new Date();
	var start = Math.floor( date.getTime() / (1000 * 60 * 60 * 24) );
	var end = start + 30;
	
	var months = new Array('January','February','March','April','May','June','July','August','September','October','November','December');
	
	$("#date-range").slider({
		range: true,
		min: start,
		max: end,
		values: [start + 3, end - 3],
		slide: function(event, ui) {
			updateLabels(ui.values[0], ui.values[1]);
		},
		change: function(event, ui) {
			var start = ui.values[0] * 24 * 60 * 60; // This is the epoch time of the first date
			var end 	= ui.values[1] * 24 * 60 * 60; // This is the epoch time of the second date
			// Do your map changing stuff here.
		}
	});
	
	updateLabels($("#date-range").slider("values", 0), $("#date-range").slider("values", 1));
	
	function updateLabels(left, right) {
		$('header #label-left span').text(dateText(left));
		$('header #label-right span').text(dateText(right));
		setTimeout( function() { $('header #label-left').css('right', 100-parseFloat($('#date-range a:first').css('left'))+'%'); }, 10);
		setTimeout( function() { $('header #label-right').css('left', $('#date-range a:last').css('left')); }, 10);
	}
	
	function dateText(date) {
		var d = new Date(date * 24 * 60 * 60 * 1000);
		return months[d.getMonth()] + ' ' + d.getDate();
	}
	
});

$(function() {
	$('#toggle-aside').click(function() {
		$(document.body).toggleClass('hide-aside');
		return false;
	})
})
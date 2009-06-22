$(function() {
	var date = new Date();
	var start = Math.floor( date.getTime() / (1000 * 60 * 60 * 24) );
	var end = start + 30;
	
	var months = new Array('January','February','March','April','May','June','July','August','September','October','November','December');
	
	var sliderElement = $('#date-range');
	
	sliderElement.data('start', start + 3).data('end', end - 3).slider({
		range: true,
		min: start,
		max: end,
		values: [sliderElement.data('start'), sliderElement.data('end')],
		slide: function(event, ui) {
			updateLabels(ui.values[0], ui.values[1]);
		},
		change: function(event, ui) {
			$(this).data('start', ui.values[0]); // This is the epoch time of the first date
			$(this).data('end', ui.values[1]);   // This is the epoch time of the second date
			$('#map').trigger('map:timeframechange');
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
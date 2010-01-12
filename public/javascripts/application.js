$(function() {
  var date = new Date();
  var startDate = new Date((Math.floor(date.getTime()/(1000 * 60 * 60 * 24))-15)* 1000 * 60 * 60 * 24);
  var start = 0;
  var end = (start + 30) * 3;
  var sliderElement = $('#date-range');

  sliderElement.data('start', dateForValue(.25*(end-start)))
    .data('end', dateForValue(.75*(end-start)))
    .slider({
      range: true,
      min: start,
      max: end,
      values: [Math.floor(.25*(end-start)), Math.floor(.75*(end-start))],
      slide: function(event, ui) {
	updateLabels(ui.values[0], ui.values[1]);
      },  
      change: function(event, ui) {
	$(this).data('start', dateForValue(ui.values[0]));
	$(this).data('end', dateForValue(ui.values[1]));
	Map.fetch();
      }
    });

  updateLabels($("#date-range").slider("values", 0), $("#date-range").slider("values", 1));

  function updateLabels(left, right) {
    $('#label-left span').text(dateText(left));
    $('#label-right span').text(dateText(right));
    // setTimeout( function() { $('#label-left').css('right', 100-parseFloat($('#date-range a:first').css('left'))+'%'); }, 10);
    // setTimeout( function() { $('#label-right').css('left', $('#date-range a:last').css('left')); }, 10);
  }

  function dateForValue(value) {
    var d = new Date(Math.floor(value/3+(startDate.getTime() / (24 * 60 * 60 * 1000))) * 24 * 60 * 60 * 1000);
    return d;
  }

  function dateText(n) {
    return $.fn.strftime(dateForValue(n), '%B %D');
  }

});

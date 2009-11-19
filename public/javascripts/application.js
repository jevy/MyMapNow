var tl, band;
$(function() {
  /*var date = new Date();
  var startDate = new Date((Math.floor(date.getTime()/(1000 * 60 * 60 * 24))-15)* 1000 * 60 * 60 * 24);
  var start = 0;
  var end = (start + 30) * 3;
  var sliderElement = $('#date-range');
  */

  var bandInfos = [
    Timeline.createBandInfo({
        width:          "100%", 
        intervalUnit:   Timeline.DateTime.DAY, 
        intervalPixels: 100
    })];
  tl = Timeline.create(document.getElementById("timeline"), bandInfos);
  band = tl.getBand(0);
  // items/in_bounds: begin_at = band.getMinVisibleDate());
  // items/in_bounds: end_at = band.getMaxVisibleDate());

  /*
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
    $('header #label-left span').text(dateText(left));
    $('header #label-right span').text(dateText(right));
    setTimeout( function() { $('header #label-left').css('right', 100-parseFloat($('#date-range a:first').css('left'))+'%'); }, 10);
    setTimeout( function() { $('header #label-right').css('left', $('#date-range a:last').css('left')); }, 10);
  }

  function dateForValue(value) {
    var d = new Date(Math.floor(value/3+(startDate.getTime() / (24 * 60 * 60 * 1000))) * 24 * 60 * 60 * 1000);
    return d;
  }

  function dateText(n) {
    return $.fn.strftime(dateForValue(n), '%B %D');
  }
  */

});

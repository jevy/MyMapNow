$(function() {
  $(document).bind('map:change', function(event, bounds, timeframe) {
    $.getJSON('/items.js', {
        southwest: ''+bounds.getSouthWest().lat()+','+bounds.getSouthWest().lng(),
        northeast: ''+bounds.getNorthEast().lat()+','+bounds.getNorthEast().lng(),
        start: ''+timeframe.start.getFullYear()+'-'+(timeframe.start.getMonth()+1)+'-'+timeframe.start.getDate()+'T'+timeframe.start.getHours()+':00',
        end: ''+timeframe.end.getFullYear()+'-'+(timeframe.end.getMonth()+1)+'-'+timeframe.end.getDate()+'T'+timeframe.end.getHours()+':00'
      }, function(data) {
      // Add new items
      $.each(data, function() {
        Map.addItem(this);
      });
    });
  });
});
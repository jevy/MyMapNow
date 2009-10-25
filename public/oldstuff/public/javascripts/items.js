$(function() {
  $(document).bind('map:change', function(event, bounds, timeframe) {
    $.getJSON('/items.js', {
        southwest: ''+bounds.getSouthWest().lat()+','+bounds.getSouthWest().lng(),
        northeast: ''+bounds.getNorthEast().lat()+','+bounds.getNorthEast().lng(),
        start: $.fn.strftime(timeframe.start, '%Y-%m-%d %H:%M'),
        end: $.fn.strftime(timeframe.end, '%Y-%m-%d %H:%M')
      }, function(data) {
      // Add new items
      $.each(data, function() {
        Map.addItem(this);
      });
    });
  });
});
$(function() {
    $(document).bind('map:change', function(event, bounds, timeframe) {
        $.getJSON('/items/in_bounds.js',
        {
            southwest: '' + bounds.getSouthWest().lat() + ',' + bounds.getSouthWest().lng(),
            northeast: '' + bounds.getNorthEast().lat() + ',' + bounds.getNorthEast().lng(),
            start: $.fn.strftime(timeframe.start, '%a %b %d %Y %H:%M:%S'),
            end: $.fn.strftime(timeframe.end, '%a %b %d %Y %H:%M:%S')
        },
                function(data) {
                    // Add new items
                    $.each(data, function() {
                        Map.addItem(this.item);
                    });
                    MMNTimeline.load_events(data);
                });
    });
});

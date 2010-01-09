$('#event-list li').live('click', function(event) {
    var $this = $(this);
    $('#event-list li.active').each(function() {
        $(this).data('info').close();
        Map.setMarkerToDefaultState($(this).data('marker'));
    }).removeClass('active');

    if (!$this.data('info')) {
        $this.data('info', new google.maps.InfoWindow({
            content: $this.html(),
            size: new google.maps.Size(250, 150),
            disableAutoPan: true
        }));
    }

    $this.addClass('active');
    Map.setMarkerToActiveState($this.data('marker'));
    Map.map.setCenter($this.data('marker').getPosition());
    $this.data('info').open(Map.map, $this.data('marker'));
    MMNTimeline.load_event($this.data('item'));
});

var OldMap = {
    initialize: function() {
        Map.map = new google.maps.Map($('#map')[0], {
            zoom: 13,
            center: new google.maps.LatLng(45.420833, -75.69),
            mapTypeId: google.maps.MapTypeId.ROADMAP
        });

        $("#date-range").change();
        google.maps.event.addListener(Map.map, 'bounds_changed', function() {
            Map.fetch();
        });
    },

    fetch: function() {
        var bounds = Map.map.getBounds();
        var timeframe = {
            start: MMNTimeline.band.getMinVisibleDate(),
            end: MMNTimeline.band.getMaxVisibleDate()
        };
        Map.cleanup();
        $(document).trigger('map:change', [bounds, timeframe]);
    },

    addItem: function(item) {
        var id = item.id;

        if (!$('#event-list li[data-item-id=' + id + ']')[0]) {
            var point = new google.maps.LatLng(item.latitude, item.longitude);

            var $li = $('<li class="' + item.kind + '" data-item-id="' + item.id + '"></li>').appendTo('#event-list ol');
            $li.append('<h2>' + item.title + '</h2><br />');
            $li.append('<p class="time"><br />Start Time: ' + (item.begin_at) + '</p>');
            if (item.end_at) {
                $li.append('<p class="time"><br />End Time: ' + (item.end_at) + '</p>');
            }
            $li.append('<p class="address"><br />' + (item.address || '') + '</p>');
            $li.append('<p class="description"><br />' + (item.description || '') + '</p>');
            if (item.url) {
                $li.append('<p class="link"><a href="' + item.url + '" target="_blank">More...</a>');
            }

            $li.data('marker', new google.maps.Marker({
                position: point,
                map: Map.map,
                title: item.title,
                icon: "images/pin_off.png"
            }));

            $li.data('item', item);

            google.maps.event.addListener($li.data('marker'), 'click', function() {
                Map.showInfoWindow(id);
                MMNTimeline.load_event(item);
            });

            google.maps.event.addListener($li.data('marker'), 'mouseover', function() {
                $('#event-list li[data-item-id=' + id + ']').css('background', '#c2ebff');
                $('#event-list li[data-item-id=' + id + ']').css('color', '#6e6e6e');
                $('#event-list a').css('color', '#6e6e6e');
                Map.setMarkerToActiveState($li.data('marker'));
            });
            google.maps.event.addListener($li.data('marker'), 'mouseout', function() {
                $('#event-list li[data-item-id=' + id + ']').css('background', '');
                $('#event-list li[data-item-id=' + id + ']').css('color', '');
                $('#event-list a').css('color', '');
                Map.setMarkerToDefaultState($li.data('marker'));
            });
        }
    },

    showInfoWindow: function(id) {
        $('#event-list li[data-item-id="' + id + '"]:first').click();
    },

    highlight: function(item) {
        Map.map.set_center(new google.maps.LatLng(item.latitude, item.longitude));
        Map.addItem(item);
        Map.showInfoWindow(item.id);
    },

    cleanup: function() {
        $('#event-list li').each(function() {
            if ($(this).data('info')) $(this).data('info').close();
            $(this).data('marker').setMap(null);
            $(this).remove();
            MMNTimeline.eventSource.clear();
        });
    },

    _markerImages: {},
    markerImages: function(kind, item) {
        if (!Map._markerImages[kind]) {
            var url = item.find('div').css('background-image').match(/\((.*)\)/)[1];
            var y = item.find('div').css('background-position').match(/-(\d+)/)[1];
            Map._markerImages[kind] = new google.maps.MarkerImage(url,
                    new google.maps.Size(23, 25),
                    new google.maps.Point(0, y),
                    new google.maps.Point(11, 20));
        }
        return Map._markerImages[kind];
    }
};

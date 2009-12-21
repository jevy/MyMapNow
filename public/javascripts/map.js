var Map = {
    initialize: function() {
        var lat = GeoIP.latitude();
        var lng = GeoIP.longitude();
        Map.map = new google.maps.Map($('#map')[0], {
            zoom: 13,
            center: new google.maps.LatLng(lat, lng),
            mapTypeControl: false,
            mapTypeId: google.maps.MapTypeId.ROADMAP
        });
        // FIXME: the next line is untested
        google.maps.event.addListener(Map.map, 'dragend', function() {
            Map.fetch();
        });
    },
    updateSearchBoxWithCurrentLocation: function() {
        $('input[name=search-box]').val(GeoIP.city() + ', ' + GeoIP.region() + ', ' + GeoIP.country());
    },
    moveTo: function(location) { // FIXME: untested
        Map.map.panTo(location);
    },

    setMarkerToActiveState: function(marker) {
        if (marker != undefined) {
            marker.setIcon("/images/pin_on.png");
        }
    },

    setMarkerToDefaultState: function(marker) {
        if (marker != undefined) {
            marker.setIcon("/images/pin_off.png");
        }
    },

    search: function(query) { // FIXME: the callback is untested
        var geocoder = new google.maps.Geocoder();
        geocoder.geocode({ 'address': query }, function(response, status) {
            if (status == google.maps.GeocoderStatus.OK) {
                Map.moveTo(response[0].geometry.location);
                $('input[name=search-box]').val(response[0].formatted_address);
            }
        });
    },
    whatsMyLocation: function() { // FIXME: untested
        Map.updateSearchBoxWithCurrentLocation();
        Map.search($('#search-box').val());
    },
    cleanup: OldMap.cleanup,
    fetch: OldMap.fetch,
    showInfoWindow: OldMap.showInfoWindow,
    addItem: OldMap.addItem,
    _markerImages: OldMap._markerImages,
    markerImages: OldMap.markerImages
};

$(document).bind('map:change', Map.cleanup);
$(document).ready(function() {
    Map.initialize();
    Map.updateSearchBoxWithCurrentLocation();
    Map.fetch();
});
//$(Map.search('Ottawa, ON'));

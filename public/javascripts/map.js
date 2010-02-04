var Map = {

  updateSearchBoxWithCurrentLocation: function() {
    $('input[name=search-box]').val(GeoIP.city() + ', ' + GeoIP.region() + ', ' + GeoIP.country());
  },
  moveTo: function(location) { // FIXME: untested
    Map.map.panTo(location);
  },
  search: function(query) { // FIXME: the callback is untested
    var geocoder = new google.maps.Geocoder();
    geocoder.geocode({ 'address': query }, function(response, status) {
      if (status == google.maps.GeocoderStatus.OK) {
	Map.moveTo(response[0].geometry.location);
      }
    });
  },
  initialize: OldMap.initialize,
  cleanup: OldMap.cleanup,
  fetch: OldMap.fetch,
  showInfoWindow: OldMap.showInfoWindow,
  addItem: OldMap.addItem,
  _markerImages: OldMap._markerImages,
  markerImages: OldMap.markerImages
};

$(document).bind('map:change', Map.cleanup);
$(Map.initialize);

// For testing purposes only - remove before launch!
$(Map.search('Ottawa, ON'));
$(function() { $('input[name=search-box]').val('Ottawa, ON'); });

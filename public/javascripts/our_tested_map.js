var Map = {
  initialize: function() {
    var lat = GeoIP.latitude();
    var lng = GeoIP.longitude();
    Map.map = new google.maps.Map($('#map')[0], {
      zoom: 13,
      center: new google.maps.LatLng(lat, lng),
      mapTypeId: google.maps.MapTypeId.ROADMAP
    });
  },
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
  }
};

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
  }
};

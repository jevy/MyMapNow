var Map = {
  initialize: function() {
    var lat = geoip_latitude();
    var lng = geoip_longitude();
    Map.map = new google.maps.Map($('#map')[0], {
      zoom: 13,
      center: new google.maps.LatLng(lat, lng),
      mapTypeId: google.maps.MapTypeId.ROADMAP
    });
  }
};

$(Map.initialize);

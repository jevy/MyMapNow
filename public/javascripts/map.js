var items;
var Map = {
  initialize: function() {
    Map.map = new google.maps.Map($('#map')[0], {
      zoom: 13,
      center: new google.maps.LatLng(45.420833, -75.69),
      mapTypeId: google.maps.MapTypeId.ROADMAP
    });
    
    google.maps.event.addListener(Map.map, 'bounds_changed', function() {
      var bounds = Map.map.get_bounds();
    
      $.getJSON('/items.js', {
          southwest: ''+bounds.getSouthWest().lat()+','+
            bounds.getSouthWest().lng(),
          northeast: ''+bounds.getNorthEast().lat()+','+ 
            bounds.getNorthEast().lng()
          }, function(data) {
        items = data;
        $.each(data, function() {
          var point = new google.maps.LatLng(this.latitude, this.longitude);
          new google.maps.Marker({
              position: point, 
              map: Map.map, 
              title: this.title, 
              icon: new google.maps.MarkerImage("/stylesheets/images/pointer-blue.png",
                new google.maps.Size(23, 25),
                new google.maps.Point(0,0),
                new google.maps.Point(11,20))
          });
          
          $('<li class="type-1"><div></div><h2>' + this.title + '</h2><p class="address">'+this.address+'<p class="description">'+this.description+'</p></li>').appendTo('aside ol');
        });
      });
    });
  }
}

$(Map.initialize);

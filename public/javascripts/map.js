$('aside li').live('click', function(event) {
  var $this = $(this);
  if (Map.activeInfoWindow) Map.activeInfoWindow.close();
  
  Map.activeInfoWindow = new google.maps.InfoWindow({
    content: $this.html(),
    size: new google.maps.Size(250,50)
  });

  $('aside li').removeClass('active');
  $this.addClass('active');
  Map.activeInfoWindow.open(Map.map, $this.data('marker'));
});

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

        $.each(data, function() {
          var id = this._id;
          var point = new google.maps.LatLng(this.latitude, this.longitude);
          
          var $li = $('<li class="type-1" data-item-id="'+this._id+'"><div></div><h2>' + this.title + '</h2><p class="address">'+this.address+'<p class="description">'+this.description+'</p></li>').appendTo('aside ol');
          
          $li.data('marker', new google.maps.Marker({
              position: point, 
              map: Map.map, 
              title: this.title, 
              icon: new google.maps.MarkerImage("/stylesheets/images/pointer-blue.png",
                new google.maps.Size(23, 25),
                new google.maps.Point(0,0),
                new google.maps.Point(11,20))
          }));
          
          google.maps.event.addListener($li.data('marker'), 'click', function() {
            $('aside li[data-item-id="'+id+'"]:first').click();
          });
          
        });
      });
    });
  }
}

$(Map.initialize);

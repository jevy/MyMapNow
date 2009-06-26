$('aside li').live('click', function(event) {
  var $this = $(this);
  $('aside li.active').each(function() {
    $(this).data('info').close();
  }).removeClass('active');
  
  if(!$this.data('info')) {
    $this.data('info', new google.maps.InfoWindow({
      content: $this.html(),
      size: new google.maps.Size(250,150)
    }));
  }

  $this.addClass('active');
  $this.data('info').open(Map.map, $this.data('marker'))
});

var Map = {
  initialize: function() {
    Map.map = new google.maps.Map($('#map')[0], {
      zoom: 13,
      center: new google.maps.LatLng(45.420833, -75.69),
      mapTypeId: google.maps.MapTypeId.ROADMAP
    });

    $('#map').bind('map:timeframechange', function() {
      Map.fetch();
    });
    $("#date-range").change();
    google.maps.event.addListener(Map.map, 'bounds_changed', function() {
      Map.fetch();
    });
  },
  
  fetch: function() {
    var bounds = Map.map.get_bounds();
    
    var start = new Date($('#date-range').data('start') * 1000 * 24 * 60 * 60)
    var end = new Date($('#date-range').data('end') * 1000 * 24 * 60 * 60)
  
    $.getJSON('/items.js', {
        southwest: ''+bounds.getSouthWest().lat()+','+
          bounds.getSouthWest().lng(),
        northeast: ''+bounds.getNorthEast().lat()+','+ 
          bounds.getNorthEast().lng(),
        start: ''+start.getFullYear()+'-'+(start.getMonth()+1)+'-'+start.getDate(),
        end: ''+end.getFullYear()+'-'+(end.getMonth()+1)+'-'+end.getDate()
        }, function(data) {
      
      // Remove items out of view
      var newIds = $.map(data, function(item) { return item._id });
      $('aside li').each(function() {
        var $this = $(this);
        if ($.inArray($this.attr('data-item-id'), newIds) == -1) {
          if($this.data('info')) $this.data('info').close();
          $this.data('marker').set_map(null);
          $this.remove();
        }
      });
      
      // Add new items
      $.each(data, function() {
        Map.addItem(this);
      });
    });
  },
  
  addItem: function(item) {
    var id = item._id;
    
    if(!$('aside li[data-item-id=' + id + ']')[0]) {
      var point = new google.maps.LatLng(item.latitude, item.longitude);
    
      var $li = $('<li class="'+item.kind+'" data-item-id="'+item._id+'"><div></div><h2>' + item.title + '</h2><p class="address">'+item.address+'<p class="description">'+item.body+'</p></li>').appendTo('aside ol');

      $li.data('marker', new google.maps.Marker({
          position: point, 
          map: Map.map, 
          title: item.title, 
          icon: Map.markerImages(item.kind, $li)
      }));
    
      google.maps.event.addListener($li.data('marker'), 'click', function() {
        Map.showInfoWindow(id);
      });
    }
    
  },
  
  showInfoWindow: function(id) {
    $('aside li[data-item-id="'+id+'"]:first').click();
  },
  
  highlight: function(item) {
    Map.map.set_center(new google.maps.LatLng(item.latitude, item.longitude));
    Map.addItem(item);
    Map.showInfoWindow(item._id);
  },
  
  _markerImages: {},
  markerImages: function(kind, item) {
    if (!Map._markerImages[kind]) {
      var url = item.find('div').css('background-image').match(/\((.*)\)/)[1];
      var y = item.find('div').css('background-position').match(/-(\d+)/)[1];
      Map._markerImages[kind] =  new google.maps.MarkerImage(url,
        new google.maps.Size(23, 25),
        new google.maps.Point(0, y),
        new google.maps.Point(11,20));
    }
    return Map._markerImages[kind];
  }
};

$(Map.initialize);

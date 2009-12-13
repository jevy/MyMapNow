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
  $this.data('info').open(Map.map, $this.data('marker'));
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
    var bounds = Map.map.get_bounds();
    var timeframe = {
      start: MMNTimeline.band.getMinVisibleDate(),
      end: MMNTimeline.band.getMaxVisibleDate()
    };
    Map.cleanup();
    $(document).trigger('map:change', [bounds, timeframe]);
  },
  
  addItem: function(item) {
    var id = item.id;
    
    if(!$('aside li[data-item-id=' + id + ']')[0]) {
      var point = new google.maps.LatLng(item.latitude, item.longitude);
    
      var $li = $('<li class="'+item.kind+'" data-item-id="'+item.id+'"></li>').appendTo('aside ol');
      $li.append('<h2>' + item.title + '</h2><br />');
      $li.append('<p class="time"><br />Start Time: ' + (item.begin_at) + '</p>');
      if (item.end_at) {
				$li.append('<p class="time"><br />End Time: ' + (item.end_at) + '</p>');
      }
      $li.append('<p class="address"><br />' + (item.address || '') + '</p>');
      $li.append('<p class="description"><br />' + (item.description || '') + '</p>');
      if (item.url) {
        $li.append('<p class="link"><a href="'+item.url+'" target="_blank">More...</a>');
      }

      $li.data('marker', new google.maps.Marker({
        position: point, 
        map: Map.map,
        title: item.title, 
        icon: "images/pin_off.png"
      }));
    
      google.maps.event.addListener($li.data('marker'), 'click', function() {
        Map.showInfoWindow(id);
      });
      google.maps.event.addListener($li.data('marker'), 'mouseover', function() {
				$('aside li[data-item-id=' + id + ']').css('background', '#c2ebff');
				$('aside li[data-item-id=' + id + ']').css('color', '#6e6e6e');
				$('aside a').css('color', '#6e6e6e');
      });
      google.maps.event.addListener($li.data('marker'), 'mouseout', function() {
				$('aside li[data-item-id=' + id + ']').css('background', '');
				$('aside li[data-item-id=' + id + ']').css('color', '');
				$('aside a').css('color', '');
      });
    }
    
  },
  
  showInfoWindow: function(id) {
    $('aside li[data-item-id="'+id+'"]:first').click();
  },
  
  highlight: function(item) {
    Map.map.set_center(new google.maps.LatLng(item.latitude, item.longitude));
    Map.addItem(item);
    Map.showInfoWindow(item.id);
  },
  
  cleanup: function() {
    $('aside li').each(function() {
      if($(this).data('info')) $(this).data('info').close();
      $(this).data('marker').set_map(null);
      $(this).remove();
    });
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

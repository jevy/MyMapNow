$('aside li').live('click', function(event) {
  var $this = $(this);
  $('aside li.active').each(function() {
    $(this).data('info').close();
  }).removeClass('active');
  
  if(!$this.data('info')) {
    $this.data('info', new google.maps.InfoWindow({
      content: $this.html(),
      maxWidth: 250,
      size: new google.maps.Size(250,250)
    }));
  }

  $this.addClass('active');
  $this.data('info').open(Map.map, $this.data('marker'));
});

var Map = {
  initialize: function() {
    Map.map = new google.maps.Map($('#map')[0], {
      zoom: 13,
      center: new google.maps.LatLng(45.420833, -75.69),
      mapTypeControl: false,
      navigationControl: true,
      navigationControlOptions: {style: google.maps.NavigationControlStyle.ANDROID},
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
      start: $('#date-range').data('start'),
      end: $('#date-range').data('end')
    };
    $(document).trigger('map:change', [bounds, timeframe]);
  },
  
  addItem: function(item) {
    var MAX_TITLE_LEN = 19;
    var id = item.id;
    
    var start_time = new Date(Date.parse(item.begin_at));
    var end_time = new Date(Date.parse(item.end_at));
    var dateId = 'day-separator-' + start_time.getFullYear() + '-' + (start_time.getMonth() + 1) + '-' + start_time.getDate();
    var dateString = dateFormat(start_time, "mmmm dS, yyyy");

    if (dateString == dateFormat((new Date()).toDateString(), "mmmm dS, yyyy")) {
      dateString = 'TODAY';
    }

    if(!$('aside li[id=' + dateId + ']')[0]) {
      $('<li class="date-separator" id="' + dateId + '"><b>' + dateString + '</b></li>').appendTo('aside ol');
    }
    
    if(!$('aside li[data-item-id=' + id + ']')[0]) {
      var point = new google.maps.LatLng(item.latitude, item.longitude);

      var $li = $('<li class="'+item.kind+'" data-item-id="'+item.id+'"><div></div><h2>' + truncate(item.title, MAX_TITLE_LEN) + '</h2>');
      $li.append('<p>' + dateFormat(start_time, "h:MM TT") + ' - ' + dateFormat(end_time, "h:MM TT") + '</p>');
      $li.append('<p class="address">'+ (item.address || '') +'<p class="description">'+ (item.body || '') +'</p>');
      if (item.url) {
        $li.append('<p class="item-url"><a href="'+item.url+'" target="_blank">More...</a></p>'); 
      } 
      $('aside ol li[id=' + dateId + ']').after($li);
                
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
    Map.showInfoWindow(item.id);
  },
  
  cleanup: function() {
    // Remove items out of view
    $('aside li').each(function() {
      var $this = $(this);
      if(!Map.map.getBounds().contains($this.data('marker').getPosition())) {
          if($this.data('info')) $this.data('info').close();
          $this.data('marker').setMap(null);
          $this.remove();
      }
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

var truncate = function (str, limit) {
	var bits, i;
	bits = str.split('');
	if (bits.length > limit) {
		for (i = bits.length - 1; i > -1; --i) {
			if (i > limit) {
				bits.length = i;
			}
			else if (' ' === bits[i]) {
				bits.length = i;
				break;
			}
		}
		bits.push('...');
	}
	return bits.join('');
};

$(document).bind('map:change', Map.cleanup);
$(Map.initialize);

// For testing purposes only - remove before launch!
$(Map.search('Halifax, NS'));
$(function() { $('input[name=q]').val('Halifax, NS'); });

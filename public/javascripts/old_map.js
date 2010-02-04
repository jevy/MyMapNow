// FIXME: global to build the infoWindow output
var contentString;

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

var OldMap = {
  initialize: function() {
    Map.map = new google.maps.Map($('#map')[0], {
      zoom: 13,
      center: new google.maps.LatLng(45.420833, -75.69),
      mapTypeControl: false,
      mapTypeId: google.maps.MapTypeId.ROADMAP
    });

    //$("#date-range").change();
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
    Map.cleanup();
    $(document).trigger('map:change', [bounds, timeframe]);
  },

  addItem: function(item) {
    var MAX_TITLE_LEN = 19;
    var id = item.id;
    var url;

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
      var $li = $('<li class="'+item.kind+'" data-item-id="'+item.id+'"><div></div></li>');
      $li.append('<h2>' + truncate(item.title, MAX_TITLE_LEN) + '</h2>');
      $li.append('<p>' + dateFormat(start_time, "h:MM TT") + ' - ' + dateFormat(end_time, "h:MM TT") + '</p>');
      $li.append('<p class="address">' + (item.address || '') + '</p>' + '<p class="description">' + (item.summary || '') + '</p>');
      if (item.url) {
        $li.append('<p class="item-url"><a href="'+item.url+'" target="_blank">More...</a></p>'); 
      }      
      $('aside ol li[id=' + dateId + ']').after($li);

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
          $li.data('marker').setIcon('images/pin_on.png');
      });
      google.maps.event.addListener($li.data('marker'), 'mouseout', function() {
          $('aside li[data-item-id=' + id + ']').css('background', '');
          $('aside li[data-item-id=' + id + ']').css('color', '');
          $('aside a').css('color', '');
          $li.data('marker').setIcon('images/pin_off.png');
          //if($li.data('info')) $li.data('info').close();
      });
    }},
    
  showInfoWindow: function(id) {  
    $('aside li[data-item-id="'+id+'"]:first').click();  
  },
  
  highlight: function(item) {
    Map.map.set_center(new google.maps.LatLng(item.latitude, item.longitude));
    Map.addItem(item);
    Map.showInfoWindow(item.id);
  },
  
  cleanup: function() {
      $('aside li[data-item-id]').each(function() {
          if($(this).data('info')) $(this).data('info').close();
            $(this).data('marker').setMap(null);
          $(this).remove();
      });
      $('aside li').each(function() {
          $(this).remove();
      });
  },
  
  _markerImages: {},
  markerImages: function(kind, item) {
    if (!Map._markerImages[kind]) {
      var url = ('images/pin_off.png');
      var y = item.find('div').css('background-position').match(/-(\d+)/)[1];    // These lines are causing some errors in IE
      Map._markerImages[kind] =  new google.maps.MarkerImage(url,
        new google.maps.Size(23, 30),
        new google.maps.Point(0, y),
        new google.maps.Point(0, 0),
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
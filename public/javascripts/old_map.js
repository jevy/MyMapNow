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
    var bounds = Map.map.getBounds();
    var timeframe = {
      start: $('#date-range').data('start'),
      end: $('#date-range').data('end')
    };
    Map.cleanup();
    $(document).trigger('map:change', [bounds, timeframe]);
  },

  addItem: function(item) {
    var id = item.id;

    var start_time = new Date(Date.parse(item.begin_at));
    var end_time = new Date(Date.parse(item.end_at));
    var dateId = 'day-separator-' + start_time.getFullYear() + '-' + (start_time.getMonth() + 1) + '-' + start_time.getDate();
    var dateString = start_time.toDateString();

    if (dateString == (new Date()).toDateString()) {
      dateString = 'TODAY';
    }

    if(!$('aside li[id=' + dateId + ']')[0]) {
      $('<li class="date-separator" id="' + dateId + '"><b>' + dateString + '</b></li>').appendTo('aside ol');
    }

    // for some reason addItem() is called twice for each item
    if(!$('aside li[data-item-id=' + id + ']')[0]) {
      var point = new google.maps.LatLng(item.latitude, item.longitude);
      var $li = $('<li class="'+item.kind+'" data-item-id="'+item.id+'"><div></div></li>')
      $li.append('<h2>' + item.title + '</h2>');
      $li.append('<p>' + (start_time.format()) );
      if (item.end_at) {
				$li.append(' ' + (end_time.format()) );
      }
      $li.append(' ' + '</p>');
      $li.append('<p class="address">' + (item.address || '') + '</p>');
      $li.append('<p class="description">' + (item.summary || '') + '</p>');
      if (item.url) {
        $li.append('<p class="link"><a href="'+item.url+'" target="_blank">More...</a>');
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
          //Map.setMarkerToActiveState($li.data('marker')); // This is for the hover-over when we have the pin graphic
      });
      google.maps.event.addListener($li.data('marker'), 'mouseout', function() {
          $('aside li[data-item-id=' + id + ']').css('background', '');
          $('aside li[data-item-id=' + id + ']').css('color', '');
          $('aside a').css('color', '');
          //Map.setMarkerToDefaultState($li.data('marker')); // This is for the hover-over when we have the pin graphic
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
      var url = item.find('div').css('background-image').match(/\((.*)\)/)[1];  // FIXME:
      var y = item.find('div').css('background-position').match(/-(\d+)/)[1];		// These lines are causing some errors in IE
      Map._markerImages[kind] =  new google.maps.MarkerImage(url,
        new google.maps.Size(23, 30),
        new google.maps.Point(0, y),
        new google.maps.Point(0, 0),
        new google.maps.Point(11,20));
    }
    return Map._markerImages[kind];
  }
};

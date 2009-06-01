jQuery(function($) {
  $('#map').googlemap();
});


$.fn.googlemap = function() {
  if(!GBrowserIsCompatible()) return this;
  return this.each(function() {
    var map = new GMap2(this);
    this.data('map', map);

    // Nothing works if the map is not centered first
    map.setCenter(new GLatLng(42.77309, -86.101754), 12);
    map.enableScrollWheelZoom();
    map.addControl(new GLargeMapControl());
    map.addControl(new GMapTypeControl());
    map.addControl(new GScaleControl());
    map.addControl(new GOverviewMapControl());
    
    // listen for clicks
    GEvent.addListener(map, 'click', function(overlay, point) {
      if (overlay) {
        // we now need a check here in case the overlay is the info window
        // only our icons will have a .html property
        if (overlay.html) {
          overlay.openInfoWindowHtml(overlay.html);
        }
      } else if (point) {
        //whatever you want to happen if you don't click on an overlay.
      }
    });
    GEvent.addListener(map, "moveend", this.refreshMarkers);
    GEvent.addListener(map, "zoomend", this.refreshMarkers);
    this.refreshMarkers();
    $(window).unload(GUnload);
    $(this).removeClass('loading');
  });
}
    
//     }
//   },
//   
//   refreshMarkers: function() {
//     var bounds = Map.map.getBounds();
//     
//     new Ajax.Request('/locations.json', {method: 'get', 
//       parameters: {callback: 'Map.callback', 
//         northeast: bounds.getNorthEast().toUrlValue(),
//         southwest: bounds.getSouthWest().toUrlValue()},
//       onFailure: Map.ajaxError} );
//   },
//   
//   callback: function(data) {
//     if(!Map.errors(data)) {
//       if(data.locations) data.locations.each(Map.mapLocation);
//       if(data.location)     Map.mapLocationAndFocus(data);
//     }
//   },
//   
//   mapLocation: function(data) {
//     if (!Map.markers[data.location.id]) {
//       var point = new GLatLng(data.location.geocoding.geocode.latitude, data.location.geocoding.geocode.longitude);
//       Map.markers[data.location.id] = new GMarker(point, {icon:Map.icon(data.location.signs)});
//       Map.markers[data.location.id].html = '<span class="'+data.location.signs.toLowerCase()+'">'+data.location.street+'</span>'+data.location.city+', '+data.location.state+' '+data.location.zip+'<br>Reported '+Date.parseISO8601(data.location.created_at).strftime('%B %d, %i:%M %p')+'<br><a href="/locations/'+data.location.id+'/edit">Edit</a> | <a href="/locations/'+data.location.id+'" class="destroy">Remove</a>';
//       Map.clusterer.AddMarker(Map.markers[data.location.id], data.location.street+', '+data.location.city+', '+data.location.state)
//       return point;
//     }
//   },
// 
//   mapLocationAndFocus: function(data) {
//     Map.map.setCenter(Map.mapLocation(data), 14);
//     $('map').scrollTo();
//     Map.showOverlay.delay(0.5, data.location);
//   },
// 
//   showOverlay: function(location) {
//     Map.markers[location.id].openInfoWindowHtml(Map.markers[location.id].html);
//   },
//   
//   findLocation: function(location_path) {
//     var id = location_path.match(/\d+$/)[0];
//     if (Map.markers[id]) {
//       Map.showOverlay({id: id});
//       $('map').scrollTo();      
//     } else {
//       new Ajax.Request(location_path+'.json', {method: 'get', 
//         parameters: {callback: 'Map.callback'},
//         onFailure: Map.ajaxError} );
//     }
//   },
//   
//   errors: function(data) {
//     $$('form .error').invoke('remove');
//     if (data.errors) {
//       var form = $$('form').first();
//       var messages = data.errors.map(function(error) {
//         var message = '';
//         if (error[0] != 'base') message = error[0].capitalize() + ' ';
//         return '<li>' + message + error[1] + '</li>';
//       });
//       form.insert({top: '<ul class="error">' + messages.join('') + '</ul>'});
//     }
//     return data.errors && !data.errors.empty();
//   },
//   
//   ajaxError: function() {
//     Map.errors({errors: [['base', "Sorry, there has been an unexpected error. We have been notified and will look into it. Please contact us if you'd like to know what we discover."]]});
//   },
//   
//   icons: {},
//   
//   icon: function(color) {
//     if (!Map.icons[color]) {
//       Map.icons[color] = new GIcon(G_DEFAULT_ICON);
//       Map.icons[color].image = '/images/'+ color.toLowerCase() + '.png';
//       Map.icons[color].shadow = '/images/sign_shadow.png';
//       Map.icons[color].iconSize = new GSize(13, 19);
//       Map.icons[color].shadowSize = new GSize(13, 19);
//       Map.icons[color].iconAnchor = new GPoint(7, 16);
//       Map.icons[color].infoWindowAnchor = new GPoint(7, 16);    
//     }
//     return Map.icons[color];
//   }
// }
// 

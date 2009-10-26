$(document).bind('map:change', function(event, bounds, timeframe) {
  var flickrParams = {
    format: 'json',
    method: 'flickr.photos.search',
    api_key: 'f44ef3af5a0463b8ab31ce8c9dc38427',
    bbox:''+bounds.getSouthWest().lng()+','+bounds.getSouthWest().lat()+','+bounds.getNorthEast().lng()+','+bounds.getNorthEast().lat(),
    min_taken_date: $.fn.strftime(timeframe.start, '%Y-%m-%d %H:%M'),
    max_taken_date: $.fn.strftime(timeframe.end, '%Y-%m-%d %H:%M'),
    per_page: 20,
    extras: 'geo',
    sort: 'date-taken-desc',
    accuracy: '13-16'
  };
  
  $.ajax({
    type: 'GET',
    url: 'http://api.flickr.com/services/rest/',
    data: flickrParams,
    success: function(data) {
      $.each(data.photos.photo, function() {
        Map.addItem({
          kind: 'photo',
          _id: 'flickr_' + this.id,
          title: this.title,
          body: '<img src="http://farm' + this.farm + '.static.flickr.com/' + this.server + '/' + this.id + '_' + this.secret + '_m.jpg">',
          latitude: this.latitude,
          longitude: this.longitude,
          approved: true
        });
      });
    },
    dataType: 'jsonp',
    jsonp: 'jsoncallback'
  });
});

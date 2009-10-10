var GeoIP = {
  latitude: function() { return geoip_latitude(); },
  longitude: function() { return geoip_longitude(); },
  city: function() { return geoip_city(); },
  region: function() { return geoip_region(); },
  country: function() { return geoip_country(); }
}

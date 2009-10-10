describe('Map', function() {
  it('should load the map at my current location', function() {
    spyOn(google.maps, 'Map');
    spyOn(google.maps, 'LatLng');
    spyOn(GeoIP, 'latitude').andReturn('1');
    spyOn(GeoIP, 'longitude').andReturn('2');

    Map.initialize();

    expect(google.maps.LatLng).wasCalledWith('1', '2');
  });
});

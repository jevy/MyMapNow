describe('Map', function() {
  it('should load the map at my current location', function() {
    spyOn(google.maps, 'Map');
    spyOn(google.maps, 'LatLng');
    spyOn(GeoIP, 'latitude').andReturn('1');
    spyOn(GeoIP, 'longitude').andReturn('2');

    Map.initialize();

    expect(google.maps.LatLng).wasCalledWith('1', '2');
  });

  it('should update the current location into the search box', function() {
    spyOn(GeoIP, 'city').andReturn('Foo');
    spyOn(GeoIP, 'region').andReturn('Bar');
    spyOn(GeoIP, 'country').andReturn('Baz');

    $('#jasmine_content').append('<input type="text" name="search-box" value="Hello" />');

    Map.updateSearchBoxWithCurrentLocation();
    expect($('input[name=search-box]').val()).toEqual('Foo, Bar, Baz');
  });
});

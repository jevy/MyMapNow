//jasmine.include("../../public/javascripts/map.js");

updateSearchBox = function() {
  $("#location-search").val(geoip_city() + ", " + geoip_region());
}

describe('Search Box', function () {
  it('should update the search box', function() {
    spyOn('geoip_city').andReturn('Ottawa');
    spyOn('geoip_region').andReturn('ON');

    expect($("#location-search").val).wasCalledWith('Ottawa, ON');

    updateSearchBox();
  });
});

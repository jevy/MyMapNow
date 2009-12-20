describe('Map', function() {
    beforeEach(function () {
        $('#jasmine_content').append('<aside><ol></ol></aside>');
        $('#jasmine_content').append('<div id="map"></div>');
    });

    afterEach(function () {
        $('#jasmine_content').children().remove();
    });

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

    it('should reposition the map when the search location changes', function() {
        var geocoderSpy = jasmine.createSpy();
        geocoderSpy.geocode = function () {
        };

        spyOn(google.maps, 'Map');
        spyOn(google.maps, 'LatLng');
        spyOn(geocoderSpy, 'geocode');
        spyOn(google.maps, 'Geocoder').andReturn(geocoderSpy);
        spyOn(GeoIP, 'latitude').andReturn('1');
        spyOn(GeoIP, 'longitude').andReturn('2');

        spyOn(Map, 'map');

        var q = 'Halifax, NS';
        Map.search(q);

        expect(geocoderSpy.geocode).wasCalledWith({ 'address': q });
        expect(Map.map.panTo).wasCalledWith('theLatLng');
    });

    //FIXME: Mike The execute should trigger the actual marker event
    // google.maps.event.trigger(markerLiEle.data('marker', 'mouseover'));
    it('should set marker pin to active state', function() {
        // setup
        Map.initialize();
        Map.addItem(single_item);
        var markerLiEle = $("aside ol li:first");

        // execute
        Map.setMarkerToActiveState(markerLiEle.data('marker'));

        // assert
        expect(markerLiEle.data('marker').icon).toEqual("/images/pin_on.png");
    });

    //FIXME: Mike The execute should trigger the actual marker event
    // google.maps.event.trigger(markerLiEle.data('marker', 'mouseout'));
    it('should set marker pin to default state', function() {
        // setup
        Map.initialize();
        Map.addItem(single_item);
        var markerLiEle = $("aside ol li:first");

        // execute
        Map.setMarkerToDefaultState(markerLiEle.data('marker'));

        // assert
        expect(markerLiEle.data('marker').icon).toEqual("/images/pin_off.png");
    });

    describe('MMNTimeline', function() {
        beforeEach(function () {
            $('#jasmine_content').append('<div id="timeline"></div>');
            MMNTimeline.initialize();
        });

        afterEach(function () {
            $('#jasmine_content #timeline').remove();
        });


        it("should load event into the eventSource", function() {
            // execute
            MMNTimeline.load_event(single_item);

            // assert
            expect(MMNTimeline.eventSource.getCount()).toEqual(1);
        });

        it("should refresh event source after adding event", function() {
            // setup
            spyOn(MMNTimeline, 'refresh_event_source');

            // execute
            MMNTimeline.load_event(single_item);

            // assert
            expect(MMNTimeline.refresh_event_source).wasCalled();
        });

        it("should not contain dupliates if we call add event twice", function() {
            // execute
            MMNTimeline.load_event(single_item);
            MMNTimeline.load_event(single_item);

            // assert
            expect(MMNTimeline.eventSource.getCount()).toEqual(1);
        });

        it("should mark the event with a css id", function() {
            // setup
            spyOn(MMNTimeline, 'mark_event_with_id');

            // execute
            MMNTimeline.load_event(single_item);

            // assert
            expect(MMNTimeline.mark_event_with_id).wasCalled();
        });


        //        describe('Duration Event', function() {
        //            it("should contain the correct css id attribute", function() {
        //                // setup
        //                spyOn(MMNTimeline, 'mark_event_with_id');
        //
        //                // execute
        //                MMNTimeline.load_event(single_item);
        //
        //                // assert
        //                expect(MMNTimeline.mark_event_with_id).wasCalled();
        //                expect($("#event-duration").length).toEqual(1);
        //            });
        //        });
        //
        //        describe('Instant Event', function() {
        //            it("should contain the correct css id attribute", function() {
        //                // setup
        //                spyOn(MMNTimeline, 'mark_event_with_id');
        //
        //                // execute
        //                MMNTimeline.load_event(single_item);
        //
        //                // assert
        //                expect(MMNTimeline.mark_event_with_id).wasCalled();
        //                expect($("#event-instant").length).toEqual(1);
        //            });
        //    });
    });
});
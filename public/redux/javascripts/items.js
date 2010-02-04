$(function() {
    var items = [
        {"item": {
            "kind": "news",
            "address": "53 Elgin Street, Ottawa, ON, CA",
            "latitude": 45.423408,
            "created_at": "2010/01/28 17:32:53 +0000",
            "title": "Canal Skate & Coffee - From National Arts Centre to Landsdowne & back",
            "begin_at": "2010/01/28 23:30:00 +0000",
            "summary": "",
            "updated_at": "2010/01/28 17:32:53 +0000",
            "end_at": "2010/01/29 02:30:00 +0000",
            "created_by_id": null,
            "url": "http://www.meetup.com/Singles-Outdoors-Club/calendar/12384543/",
            "id": 3,
            "city_wide": false,
            "longitude": -75.694816,
            "description": null,
            "approved_by_id": null}
        }, 
        {"item": {
            "kind": "news",
            "address": "174 First Avenue,, Ottawa, ON, CA",
            "latitude": 45.404714,
            "created_at": "2010/01/28 17:32:53 +0000",
            "title": "RAW Potluck",
            "begin_at": "2010/01/29 22:30:00 +0000",
            "summary": "",
            "updated_at": "2010/01/28 17:32:53 +0000",
            "end_at": "2010/01/30 01:30:00 +0000",
            "created_by_id": null,
            "url": "http://www.meetup.com/OttawaVeg/calendar/12235132/",
            "id": 4,
            "city_wide": false,
            "longitude": -75.688355,
            "description": null,
            "approved_by_id": null}
        }, 
        {"item": {
            "kind": "news",
            "address": "223 Main Street, Ottawa, ON, CA",
            "latitude": 45.407639,
            "created_at": "2010/01/28 17:32:53 +0000",
            "title": "Healing Love Academy January Meetup",
            "begin_at": "2010/01/29 23:00:00 +0000",
            "summary": "",
            "updated_at": "2010/01/28 17:32:53 +0000",
            "end_at": "2010/01/30 02:00:00 +0000",
            "created_by_id": null,
            "url": "http://www.meetup.com/Healing-Love-Academy/calendar/12113222/",
            "id": 5,
            "city_wide": false,
            "longitude": -75.677157,
            "description": null,
            "approved_by_id": null}
        }
    ];

    $.each(items, function() {
        Map.addItem(this['item']);
    });
});

var tl; // FIXME: bad globals

var MMNTimeline = {
    band: null,
    eventSource: null,
    resizeTimerID: null,

    initialize: function() {
        this.eventSource = new Timeline.DefaultEventSource(0);
        var bandInfos = [
            Timeline.createBandInfo({
                width:          "100%",
                intervalUnit:   Timeline.DateTime.DAY,
                intervalPixels: 100,
                eventSource: this.eventSource
            })];
        tl = Timeline.create(document.getElementById("timeline"), bandInfos);
        this.band = tl.getBand(0);
        this.band.addOnScrollListener(this.scroll_listener);
    },

    load_events: function(items) {
        this.eventSource.clear();
        this.eventSource.addMany(this.create_events(items));
        this.refresh_event_source();
    },

    create_events: function(items) {
        var events = new Array();
        for (var i = 0; i < items.length; i++) {
            var item = items[i].item;
            var start = Timeline.DateTime.parseIso8601DateTime(item.begin_at);
            var end = Timeline.DateTime.parseIso8601DateTime(item.begin_at);
            var evt = new Timeline.DefaultEventSource.Event(
                    start, //start
                    end, //end
                    start, //latestStart
                    end, //earliestEnd
                    true, //instant
                    item.title, //text
                    item.description //description
                    );
            events.push(evt);
        }
        return events;
    },

    refresh_event_source: function() {
        for (var i = 0; i < this.eventSource._listeners.length; i++) {
            this.eventSource._listeners[i].onAddMany();
        }
    },

    on_resize: function() {
        if (this.resizeTimerID == null) {
            this.resizeTimerID = window.setTimeout(function() {
                this.resizeTimerID = null;
                tl.layout();
            }, 500);
        }
    },

    scroll_listener: function(scrolled_band) {
        Map.fetch();
    }
}

//TODO: Might be better to have this init code in a central application file..opinions?
$(document).ready(function() {
    MMNTimeline.initialize();
});

$(window).resize(function() {
    MMNTimeline.on_resize();
});


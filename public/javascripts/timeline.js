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

    load_event: function(item) {
        this.eventSource.clear();
        this.eventSource.add(this.create_event(item));
        this.refresh_event_source();
    },

    create_event: function(item) {
        var start = Timeline.DateTime.parseIso8601DateTime(item.begin_at);
        var end = Timeline.DateTime.parseIso8601DateTime(item.end_at);
        return new Timeline.DefaultEventSource.Event(
                start, //start
                end, //end
                start, //latestStart
                end, //earliestEnd
                false, //instant
                item.title, //text
                item.description //description
                );
    },

    refresh_event_source: function() {
        for (var i = 0; i < this.eventSource._listeners.length; i++) {
            this.eventSource._listeners[i].onAddMany();
        }
    },

    scroll_listener: function(scrolled_band) {
        Map.fetch();
    }
};

// disable timeline event popup InfoWindow
Timeline.DurationEventPainter.prototype._showBubble = function(x, y, evt) {
    // do nothing       
};
$(document).ready(function() {
    MMNTimeline.initialize();
});
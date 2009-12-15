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
        this.mark_event_with_id();
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
                '', //text
                '' //description
                );
    },

    refresh_event_source: function() {
        for (var i = 0; i < this.eventSource._listeners.length; i++) {
            this.eventSource._listeners[i].onAddMany();
        }
    },

    mark_event_with_id: function() {
        $('div.timeline-band-layer-inner').filter(function() {
            return $(this).attr('name') == "events";
        }).each(function() {
            var first_child_div = $(this).children(":first-child");
            if ($(this).children().size() == 2) { // 2 children == a duration event
                first_child_div.attr("id", "event-duration");
                first_child_div.append($('<span></span>').attr("id", "round-cap"));
            } else {
                first_child_div.attr("id", "event-instant");
            }
        });
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
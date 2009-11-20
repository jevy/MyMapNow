var tl, band;
var resizeTimer = null;

var MMNTimeline = {
initialize: function() {
              var bandInfos = [
                Timeline.createBandInfo({
                    width:          "100%", 
                    intervalUnit:   Timeline.DateTime.DAY, 
                    intervalPixels: 100
                })];
              tl = Timeline.create(document.getElementById("timeline"), bandInfos);
              band = tl.getBand(0);

              band.addOnScrollListener(this.scroll_listener);
            },

on_resize: function() {
            if (resizeTimer) {
              clearTimeout(resizeTimer);
            }

            resizeTimer = setTimeout(tl.layout(), 100);
           },

scroll_listener: function(scrolled_band) {
                    // Why won't this work?
                    //$("#timeline").mouseup(Map.fetch());
                    Map.fetch();

                }

}

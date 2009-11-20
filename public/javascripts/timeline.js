var tl, band;

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

                band.addOnScrollListener(Map.fetch);
              }

}

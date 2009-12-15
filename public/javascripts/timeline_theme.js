Timeline.MMNTTheme = Timeline.ClassicTheme;

Timeline.MMNTTheme._Impl = function() {
    this.firstDayOfWeek = 0; // Sunday
    
    this.ether = {
        backgroundColors: [
            "#fff",
            "#fff",
            "#fff",
            "#fff"
        ],
        highlightColor:     "white",
        highlightOpacity:   20,
        interval: {
            line: {
                show:       true,
                color:      "white",
                opacity:    25
            },
            weekend: {
                color:      "#FFFFE0",
                opacity:    30
            },
            marker: {
                hAlign:     "Bottom",
                hBottomStyler: function(elmt) {
                    elmt.className = "timeline-ether-marker-bottom";
                },
                hBottomEmphasizedStyler: function(elmt) {
                    elmt.className = "timeline-ether-marker-bottom-emphasized";
                },
                hTopStyler: function(elmt) {
                    elmt.className = "timeline-ether-marker-top";
                },
                hTopEmphasizedStyler: function(elmt) {
                    elmt.className = "timeline-ether-marker-top-emphasized";
                },
                    
                vAlign:     "Right",
                vRightStyler: function(elmt) {
                    elmt.className = "timeline-ether-marker-right";
                },
                vRightEmphasizedStyler: function(elmt) {
                    elmt.className = "timeline-ether-marker-right-emphasized";
                },
                vLeftStyler: function(elmt) {
                    elmt.className = "timeline-ether-marker-left";
                },
                vLeftEmphasizedStyler:function(elmt) {
                    elmt.className = "timeline-ether-marker-left-emphasized";
                }
            }
        }
    };
    
    this.event = {
        track: {
            offset:         0.5, // em sets top margin of the time band
            height:         2.5, // em, sets height of the event div
            gap:            0  // em, sets margin between events
        },
        instant: { // set isDuration="false" in XML file
//            icon:           "/images/buttonLocate_on.png",
            lineColor:      "", // div bkg color
            impreciseColor: "",
            impreciseOpacity: 100, // color opacity, not text opacity
            showLineForNoText: true
        },
        duration: { // no icon
            color:          "", // div bkg color
            opacity:        70, // color opacity, not text opacity
            impreciseColor: "",
            impreciseOpacity: 70
        },
        label: {
            insideColor:    "white",  // ?
            outsideColor:   "black",  // color of event text
            width:          200 // px, width of the event div
        },
        highlightColors: [
            "#FFFF00",
            "#FFC000",
            "#FF0000",
            "#0000FF"
        ],
        bubble: {
            width:          350, // px
            height:         125, // px
            titleStyler: function(elmt) {
                elmt.className = "timeline-event-bubble-title";
            },
            bodyStyler: function(elmt) {
                elmt.className = "timeline-event-bubble-body";
            },
            imageStyler: function(elmt) {
                elmt.className = "timeline-event-bubble-image";
            },
            wikiStyler: function(elmt) {
                elmt.className = "timeline-event-bubble-wiki";
            },
            timeStyler: function(elmt) {
                elmt.className = "timeline-event-bubble-time";
            }
        }
    };
};
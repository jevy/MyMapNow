$(function() {
	var date = new Date();
	var startDate = Math.floor( date.getTime() / (1000 * 60 * 60 * 24) )-15;
	var start = 0;
	var end = (start + 30) * 3;
	
	var months = new Array('January','February','March','April','May','June','July','August','September','October','November','December');
	var increments = [['Morning', 0], ['Afternoon', 12], ['Evening', 17]];
	
	var sliderElement = $('#date-range');
	
	sliderElement.data('start', Math.floor(.25*(end-start))+startDate).data('end', Math.floor(.75*(end-start))+startDate).slider({
		range: true,
		min: start,
		max: end,
		values: [sliderElement.data('start')-startDate, sliderElement.data('end')-startDate],
		slide: function(event, ui) {
			updateLabels(ui.values[0], ui.values[1]);
		},
		change: function(event, ui) {
			$(this).data('start', Math.floor(ui.values[0]/3+startDate)); // This is the epoch time of the first date
			$(this).data('startIncrement', increments[ui.values[0]%3][1]);
			$(this).data('end', Math.floor(ui.values[1]/3+startDate));   // This is the epoch time of the second date
			$(this).data('endIncrement', increments[ui.values[1]%3][1]);
			Map.fetch();
		}
	});
	
	updateLabels($("#date-range").slider("values", 0), $("#date-range").slider("values", 1));
	
	function updateLabels(left, right) {
		$('header #label-left span').text(dateText(left));
		$('header #label-right span').text(dateText(right));
		setTimeout( function() { $('header #label-left').css('right', 100-parseFloat($('#date-range a:first').css('left'))+'%'); }, 10);
		setTimeout( function() { $('header #label-right').css('left', $('#date-range a:last').css('left')); }, 10);
	}
	
	function dateText(n) {
		var d = new Date(Math.floor(n/3+startDate) * 24 * 60 * 60 * 1000);
		return months[d.getMonth()] + ' ' + d.getDate() + ' '+ increments[n%3][0];
	}
	
});

$(function() {
	$('#toggle-aside').click(function() {
		$(document.body).toggleClass('hide-aside');
		return false;
	});
	
	var form = $('#new_item');
	form.dialog({autoOpen: false,
	  buttons: {
  	  Cancel: function() { $(this).dialog('close') },
  	  Save: function() { $(this).submit() }
  	},
  	open: function() { 
       $("#ui-datepicker-div").css("z-index", $(this).parents(".ui-dialog").css("z-index")+1); 
    }
	}).parents('.ui-dialog:first').wrap('<div class="dialog"></div>');
	// Wrap form with div to namespace themeroller
	//  http://www.filamentgroup.com/lab/using_multiple_jquery_ui_themes_on_a_single_page/#commentNumber4
	
  $(".datepicker").datepicker();
  $('#ui-datepicker-div').wrap('<div class="dialog"></div>');

	$('#add_new_item').click(function(e) {
	  e.preventDefault();
	  $('#new_item').dialog(form.dialog('isOpen') ? 'close' : 'open');
	});
	
	form.ajaxForm({dataType: 'json',
	  resetForm: true,
	  success: function(item) {
      form.dialog('close');
	    Map.highlight(item);
    }
  });
  
  $.ajaxSettings.accepts.html = $.ajaxSettings.accepts.script;
  
  $.authenticityToken = function() {
    return $('#authenticity-token').attr('content');
  };
  
  $('a.approve').live('click', function(event) {
    var link = $(this);
    event.preventDefault();
    var form = $('<form method="POST"></form>')
      .css({display:'none'})
      .attr('action', this.href)
      .append('<input type="hidden" name="_method" value="put"/>')
      .append('<input type="hidden" name="authenticity_token" value="' +
        $.authenticityToken() + '"/>')
      .insertAfter(this.parentNode);
    form.ajaxSubmit({
      success: function() {
        link.hide();
      },
      error: function() {link.replace('Cannot be approved at this time.')}
    });
  });
});

$(function() {
	var date = new Date();
	var start = Math.floor( date.getTime() / (1000 * 60 * 60 * 24) );
	var end = start + 30;
	
	var months = new Array('January','February','March','April','May','June','July','August','September','October','November','December');
	
	var sliderElement = $('#date-range');
	
	sliderElement.data('start', start + 3).data('end', end - 3).slider({
		range: true,
		min: start,
		max: end,
		values: [sliderElement.data('start'), sliderElement.data('end')],
		slide: function(event, ui) {
			updateLabels(ui.values[0], ui.values[1]);
		},
		change: function(event, ui) {
			$(this).data('start', ui.values[0]); // This is the epoch time of the first date
			$(this).data('end', ui.values[1]);   // This is the epoch time of the second date
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
	
	function dateText(date) {
		var d = new Date(date * 24 * 60 * 60 * 1000);
		return months[d.getMonth()] + ' ' + d.getDate();
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
});

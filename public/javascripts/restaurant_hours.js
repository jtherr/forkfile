
jQuery(document).ready(function() {
	//nothing
});

function initHourException() {
	initializeDatePickers();
	toggleRecurringType();
	toggleClosed();
}


function initializeDatePickers() {
	jQuery("#hour_exception_from_date").datepicker();
	jQuery("#hour_exception_to_date").datepicker();
}


function toggleRecurringType() {
	if (jQuery("#hour_exception_recurring_type").val() == "0") {
		jQuery("#to_date_div").css("display", "none");
		jQuery("#hour_exception_to_date").val("");
	} else {
		jQuery("#to_date_div").css("display", "block");
	}		
}

function toggleClosed() {
	if (jQuery("#hour_exception_closed").attr("checked")) {
		jQuery("#times").css("display", "none");
	} else {
		jQuery("#times").css("display", "block");		
	}
}


var current_day;

jQuery(document).ready(function() {
	if (jQuery("#current_day").val() == "") {
		current_day = "available";
	} else {
		current_day = jQuery("#current_day").val();
	}
	
	updateSelectedDay(current_day);
});


function updateSelectedDay(day) {
	jQuery("#specials_" + current_day + "_link").attr("class", "link ");
	jQuery("#specials_" + day + "_link").attr("class", "link selected");
	current_day = day;
	jQuery("#current_day").val(current_day)
}

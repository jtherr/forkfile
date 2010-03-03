
var current_cuisine;

jQuery(document).ready(function() {	

	if (jQuery("#current_cuisine").val() == "") {
		current_cuisine = "all";
	} else {
		current_cuisine = jQuery("#current_cuisine").val();
	}
   
	updateSelectedCuisine(current_cuisine);
	updateSelectedOrderTypes();
});



function updateSelectedCuisine(cuisine) {
	jQuery("#cuisine_" + current_cuisine + "_link").attr("class", "link ");
	jQuery("#cuisine_" + cuisine + "_link").attr("class", "link selected");
	current_cuisine = cuisine;
	jQuery("#current_cuisine").val(current_cuisine);
}

function updateSelectedOrderTypes() {
	if (jQuery('#delivery').attr("checked")) {
		jQuery('#filter_delivery').attr("class", "filter selected");
	} else {
		jQuery('#filter_delivery').attr("class", "filter");
	}

	if (jQuery('#take_out').attr("checked")) {
		jQuery('#filter_take_out').attr("class", "filter selected");
	} else {
		jQuery('#filter_take_out').attr("class", "filter");
	}
	
	if (jQuery('#specials').attr("checked")) {
		jQuery('#filter_specials').attr("class", "filter selected");
	} else {
		jQuery('#filter_specials').attr("class", "filter");
	}
	
	if (jQuery('#open').attr("checked")) {
		jQuery('#filter_open').attr("class", "filter selected");
	} else {
		jQuery('#filter_open').attr("class", "filter");
	}
}

function showResultMap() {
	jQuery("#searchResultList").css("display", "none");
	jQuery("#searchResultMap").css("display", "block");
	initializeMap();
}

function showResultList() {
	jQuery("#searchResultMap").css("display", "none");
	jQuery("#searchResultList").css("display", "block");
}

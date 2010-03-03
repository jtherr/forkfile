
var current_category;

jQuery(document).ready(function() {
	if (jQuery("#current_category").val() == "") {
		current_category = "all";
	} else {
		current_category = jQuery("#current_category").val();
	}
	
	updateSelectedCategory(current_category);
});


function updateSelectedCategory(category) {
	jQuery("#category_" + current_category + "_link").attr("class", "link ");
	jQuery("#category_" + category + "_link").attr("class", "link selected");
	current_category = category;
}

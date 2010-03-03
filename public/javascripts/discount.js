

function initDiscountOptions() {
   updateBuyOptions();
   updateGetOptions();
}


function updateBuyOptions() {
	if (jQuery("#discount_buy_options_anything").attr("checked")) {
		jQuery("#buy_amount_div").css("display", "none");
		jQuery("#buy_items_div").css("display", "none");
		
		jQuery("#discount_buy_amount").val("");
		jQuery("#discount_buy_quantity").val("");
		jQuery("#discount_buy_discount_group_id").val("");
		jQuery("#discount_buy_match_all_parts").attr("checked", false);
	} else if (jQuery("#discount_buy_options_amount").attr("checked")) {
		jQuery("#buy_amount_div").css("display", "block");
		jQuery("#buy_items_div").css("display", "none");

		jQuery("#discount_buy_quantity").val("");
		jQuery("#discount_buy_discount_group_id").val("");
		jQuery("#discount_buy_match_all_parts").attr("checked", false);
	} else if (jQuery("#discount_buy_options_items").attr("checked")) {
		jQuery("#buy_amount_div").css("display", "none");
		jQuery("#buy_items_div").css("display", "block");

		jQuery("#discount_buy_amount").val("");
		updateBuyQuantity();
	}	
}

function updateBuyQuantity() {
	if (jQuery("#discount_buy_match_all_parts").attr("checked")) {
		jQuery("#buy_quantity_div").css("display", "none");

		jQuery("#discount_buy_quantity").val("");
	} else {
		jQuery("#buy_quantity_div").css("display", "block");
	}
}


function updateGetOptions() {
	if (jQuery("#discount_get_options_items").attr("checked")) {
		jQuery("#get_amount_off_div").css("display", "none");
		jQuery("#get_percent_off_div").css("display", "none");
		jQuery("#get_items_div").css("display", "block");
		
		updateGetQuantity();
		updateGetItemsOptions();
	} else if (jQuery("#discount_get_options_amount_off").attr("checked")) {
		jQuery("#get_amount_off_div").css("display", "block");
		jQuery("#get_percent_off_div").css("display", "none");
		jQuery("#get_items_div").css("display", "none");

		jQuery("#discount_get_percent_off").val("");
		jQuery("#discount_get_for_amount").val("");
		jQuery("#discount_get_quantity").val("");
		jQuery("#discount_get_discount_group_id").val("");
		jQuery("#discount_get_match_all_parts").attr("checked", false);
	} else if (jQuery("#discount_get_options_percent_off").attr("checked")) {
		jQuery("#get_amount_off_div").css("display", "none");
		jQuery("#get_percent_off_div").css("display", "block");
		jQuery("#get_items_div").css("display", "none");

		jQuery("#discount_get_amount_off").val("");
		jQuery("#discount_get_for_amount").val("");
		jQuery("#discount_get_discount_group_id").val("");
		jQuery("#discount_get_quantity").val("");
		jQuery("#discount_get_match_all_parts").attr("checked", false);
	}
}

function updateGetQuantity() {
	if (jQuery("#discount_get_match_all_parts").attr("checked")) {
		jQuery("#get_quantity_div").css("display", "none");

		jQuery("#discount_get_quantity").val("");
	} else {
		jQuery("#get_quantity_div").css("display", "block");
	}
}

function updateGetItemsOptions() {
	if (jQuery("#discount_get_items_options_for_amount").attr("checked")) {
		jQuery("#get_for_amount_div").css("display", "block");
		jQuery("#get_amount_off_div").css("display", "none");
		jQuery("#get_percent_off_div").css("display", "none");

		jQuery("#discount_get_percent_off").val("");
		jQuery("#discount_get_amount_off").val("");
	} else if (jQuery("#discount_get_items_options_amount_off").attr("checked")) {
		jQuery("#get_for_amount_div").css("display", "none");
		jQuery("#get_amount_off_div").css("display", "block");
		jQuery("#get_percent_off_div").css("display", "none");

		jQuery("#discount_get_percent_off").val("");
		jQuery("#discount_get_for_amount").val("");
	} else if (jQuery("#discount_get_items_options_percent_off").attr("checked")) {
		jQuery("#get_for_amount_div").css("display", "none");
		jQuery("#get_amount_off_div").css("display", "none");
		jQuery("#get_percent_off_div").css("display", "block");

		jQuery("#discount_get_amount_off").val("");
		jQuery("#discount_get_for_amount").val("");
	}	
}


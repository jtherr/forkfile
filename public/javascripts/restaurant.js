

jQuery(document).ready(function() {	
	toggleTakeOut();
	toggleDelivery();
});


function toggleTakeOut() {
	if (jQuery("#restaurant_take_out").attr("checked")) {
		jQuery("#takeOutDiv").css("display", "block");
	} else {
		jQuery("#takeOutDiv").css("display", "none");		
	}
}

function toggleDelivery() {
	if (jQuery("#restaurant_delivery").attr("checked")) {
		jQuery("#deliveryDiv").css("display", "block");
	} else {
		jQuery("#deliveryDiv").css("display", "none");		
	}
}



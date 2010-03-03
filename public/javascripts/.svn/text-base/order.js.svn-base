
jQuery(document).ready(function() {
	if (jQuery("#order_order_type_delivery").attr("checked")) {
		showDelivery();
	}
	
	if (jQuery("#order_payment_type_credit_card").attr("checked")) {
		showCreditCard();
	}
	
	if (jQuery("#credit_card_selection_saved").attr("checked")) {
		showSavedCreditCard();
	} else if (jQuery("#credit_card_selection_new").attr("checked")) {
		showNewCreditCard();
	}
	
	if (jQuery("#contact_info_entered").val() == "false") {
		showContactInfoUpdate();		
	} else {
		showContactInfoStatic();		
	}
		
	if (jQuery("#delivery_address_entered").val() == "false") {
		showDeliveryAddressUpdate();		
	} else {
		showDeliveryAddressStatic();		
	}
	
	if (jQuery("#credit_card_info_entered").val() == "false") {
		showCreditCardUpdate();		
	} else {
		showCreditCardStatic();		
	}
});


function showDelivery() {
	jQuery("#deliveryDiv").css("display", "block");
}

function hideDelivery() {
	jQuery("#deliveryDiv").css("display", "none");
}


function showCreditCard() {
	jQuery("#creditCardDiv").css("display", "block");
}

function hideCreditCard() {
	jQuery("#creditCardDiv").css("display", "none");
}


function showSavedCreditCard() {
	jQuery("#newCreditCard").css("display", "none");
	jQuery("#savedCreditCard").css("display", "block");
}

function showNewCreditCard() {
	jQuery("#savedCreditCard").css("display", "none");
	jQuery("#newCreditCard").css("display", "block");
}




function showDeliveryAddressUpdate() {
	jQuery("#deliveryAddressStaticDiv").css("display", "none");
	jQuery("#deliveryAddressUpdateDiv").css("display", "block");
	
	jQuery("#contact_info_entered").val(false);
}

function showCreditCardUpdate() {
	jQuery("#creditCardStaticDiv").css("display", "none");
	jQuery("#creditCardUpdateDiv").css("display", "block");
	
	jQuery("#credit_card_info_entered").val(false);
}

function showContactInfoUpdate() {
	jQuery("#contactInfoStaticDiv").css("display", "none");
	jQuery("#contactInfoUpdateDiv").css("display", "block");
	
	jQuery("#delivery_address_entered").val(false);
}

function showDeliveryAddressStatic() {
	jQuery("#deliveryAddressUpdateDiv").css("display", "none");
	jQuery("#deliveryAddressStaticDiv").css("display", "block");
}

function showCreditCardStatic() {
	jQuery("#creditCardUpdateDiv").css("display", "none");
	jQuery("#creditCardStaticDiv").css("display", "block");
}

function showContactInfoStatic() {
	jQuery("#contactInfoUpdateDiv").css("display", "none");
	jQuery("#contactInfoStaticDiv").css("display", "block");
}









function displayOptionQuantity(checkbox, option_id) {
	if (checkbox.checked) {
		jQuery("#option_quantity_" + option_id + "_div").css("display", "inline");	
	} else {
		jQuery("#option_quantity_" + option_id + "_div").css("display", "none");
	}	
}

function addSpecialInstructions() {
	jQuery("#addSpecialInstructionsLink").css("display", "none");
	jQuery("#specialInstructionsDiv").css("display", "block");	
}

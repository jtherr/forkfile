
function initAddNotes() {
	updateGrantAmount();
	jQuery("#refund_status").bind("change", function(e) { updateGrantAmount(); } );
};


function updateGrantAmount() {
	var status = jQuery("#refund_status").val();
	
	if (status == 1 || status == 3) {
		showGrantAmount();
	} else {
		hideGrantAmount();
	}
}


function showGrantAmount() {
	jQuery("#grant_amount_div").css("display", "block");
}

function hideGrantAmount() {
	jQuery("#grant_amount_div").css("display", "none");
}



function showRefundRequest(id) {
	jQuery("#refundId").val(id);
	jQuery("#showRefundForm").submit();
}


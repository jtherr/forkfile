

jQuery(document).ready(function() {
	//empty
});


function addSize() {
	var itemSizeCounter = jQuery("#itemSizeNewCounter");
	var next = parseInt(itemSizeCounter.val());

	var item_size_names = jQuery("#item_size_names").val().split(',');
	var item_size_ids = jQuery("#item_size_ids").val().split(',');

	var options = '';
	
	for (var i=0; i<item_size_ids.length; i++) {
		options += '<option value="' + item_size_ids[i] + '">' + item_size_names[i] + '</option>';
	}

	jQuery("#itemSizesNewDiv").append(
		'<div id="itemSize_' + next + '">' +
		'	<div class="newItemSize">' +
		
		'	   <div class="field">' +
		'			<label for="name">Name</label>' +
		'			<select id="itemSize_' + next + '_item_size_name_id" name="itemSize[' + next + '][item_size_name_id]">' +

					options + 	
	
		'			</select>' +
		'   	</div>' +

		'   	<div class="field">' +
		'			<label for="special_only">Special Only</label>' +
		'			<input id="itemSize_' + next + '_special_only" type="checkbox" name="itemSize[' + next + '][special_only]" value="1" onclick="togglePrice(this, ' + next + ');" />' +
		'			<input type="hidden" value="0" name="itemSize[' + next + '][special_only]"/>' + 
		'   	</div>' +
	
		'   	<div class="field" id="price_' + next + '">' +
		'			<label for="price">Price $</label>' +
		'			<input id="itemSize_' + next + '_price" type="text" size="6" name="itemSize[' + next + '][price]"/>' +
		'       	<span class="red">*</span>' + 
		'   	</div>' +

		'		<div class="actions"><a onclick="removeSize(' + next + '); return false;" href="#">Remove Size</a></div>' +
		'	</div>' +
		'</div>'
	);

	itemSizeCounter.val(next + 1);

	updateSizes();
}

function removeSize(sizeId) {
	jQuery("#itemSize_" + sizeId).empty();
	updateSizes();
}




function addOption() {
	var optionCounter = jQuery("#optionNewCounter");
	var next = parseInt(optionCounter.val()) + 1;

	var newOption =
		'<div id="option_' + next + '" class="new_option">' +

		'	<div class="field">' + 
		'		<label for="name">Name</label>' +
		'		<input id="option_' + next + '_name" type="text" name="option[' + next + '][name]" size="30" />' +
		'       <span class="red">*</span>' + 
		'	</div>' +

		'	<div class="field">' + 
		'		<label for="allow_quantity">Allow Quantity</label>' +
		'		<input id="option_' + next + '_allow_quantity" type="checkbox" name="option[' + next + '][allow_quantity]" value="1" />' +
		'		<input type="hidden" value="' + next + '" name="option[' + next + '][allow_quantity]"/>' + 
		'	</div>' +
		
		'	<div class="field">' + 
		'		<label for="selected_by_default">Selected by Default</label>' +
		'		<input id="option_' + next + '_selected_by_default" type="checkbox" name="option[' + next + '][selected_by_default]" value="1" />' +
		'		<input type="hidden" value="' + next + '" name="option[' + next + '][selected_by_default]"/>' + 
		'	</div>' +
		
		'   <div class="field">' +
		'		<label for="additional_price">Additional Prices: </label>' +
		' 	    <div id="additionalPriceDiv_' + next + '" class="text"></div>' +
		'       <input type="hidden" id="additionalPriceCounter_' + next + '" value="0"></input>' +
		'   </div>' +

		'   <div class="actions"><a onclick="addAdditionalPrice(' + next + '); return false;" href="#">Add Additional Price</a></div>';
		

	newOption += '	<div class="actions"><a onclick="removeOption(' + next + '); return false;" href="#">Remove Option</a></div>';
	newOption += '</div>';
		
	jQuery("#optionsNewDiv").append(newOption);
	
	optionCounter.val(next);
	
	updateSizes();
}

function removeOption(optionId) {
	jQuery("#option_" + optionId).replaceWith("");
	updateSizes();
}


function addAdditionalPrice(optionId) {
	
	var additionalPriceCounter = jQuery("#additionalPriceCounter_" + optionId);
	var next = parseInt(additionalPriceCounter.val()) + 1;
	
	var item_size_ids = jQuery("#item_size_ids").val().split(',');
	var item_size_names = jQuery("#item_size_names").val().split(',');

	var options = '';

	for (var i=0; i<item_size_ids.length; i++) {
		options += '<option value="' + item_size_ids[i] + '">' + item_size_names[i] + '</option>';
	}
	
	var newAdditionalPrice =
		'   <div id="additionalPrice_' + optionId + '_' + next + '">' +
		'		<select id="option_size_' + optionId + '__' + next + '_item_size_name_id" name="option_size[' + optionId + '][' + next + '][item_size_name_id]">' +

				options + 	
	
		'		</select>' +

		'       $ <input type="text" size="6" id="option_size_' + optionId + '__' + next + '_additional_price" name="option_size[' + optionId + '][' + next + '][additional_price]"></input>' +

		'       <a onclick="removeAdditionalPrice(' + optionId + ',' + next + '); return false;" href="#">Remove</a>' +
		'       <br />' +
		'   </div>';

	jQuery("#additionalPriceDiv_" + optionId).append(newAdditionalPrice);
	
	additionalPriceCounter.val(next);

	updateSizes();
}

function removeAdditionalPrice(optionId, additionalPriceId) {
	jQuery("#additionalPrice_" + optionId + "_" + additionalPriceId).replaceWith("");
	updateSizes();
}


function displayOptions() {
	jQuery("#options").css("display", "block");
}


function showResultMap() {
	initializeMap();
}


function togglePrice(special, i) {
	if (special.checked) {
		jQuery("#price_" + i).css("display", "none");
	} else {
		jQuery("#price_" + i).css("display", "block");		
	}
}


function selectAction() {
	action_id = jQuery("#item_action_action_id").val();
	
	if (action_id == "") {
		jQuery("#action_1").css("display", "none");
		jQuery("#action_2").css("display", "none");	
	} else if (action_id == "1") {
		jQuery("#action_1").css("display", "inline");
		jQuery("#action_2").css("display", "none");	
	} else if (action_id == "2") {
		jQuery("#action_1").css("display", "none");
		jQuery("#action_2").css("display", "inline");	
	}
}

function selectAllItems() {
	jQuery("input.item_checkbox").attr("checked", true);
}

function deselectAllItems() {
	jQuery("input.item_checkbox").attr("checked", false);
}

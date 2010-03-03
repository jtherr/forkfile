var mouseX = 0;
var mouseY = 0;

var popupDisplayed = false;
var loadingDisplayed = false;

var map;


jQuery(document).ready(function() {
   jQuery("body").bind("mouseover", updateMouseLocation);
   jQuery(window).resize(updateSizes);
   
   initSearchBox();
   
   initCaptcha();
   
   //new Draggable("popupContainer", {});
});


function initCaptcha() {
	jQuery("form.captcha").append('<div class="inputfield"><input type="text" id="inputfield" name="inputfield" value=""></input></div>');
}


function initSearchBox() {
	if (jQuery("#search_keywords").val() == "" || jQuery("#search_keywords").val() == "Search for Restaurants or Food") {
		jQuery("#search_keywords").attr("class", "empty");
		jQuery("#search_keywords").val("Search for Restaurants or Food");
	}
}

function focusSearchBox() {
	if (jQuery("#search_keywords").val() == "" || jQuery("#search_keywords").val() == "Search for Restaurants or Food") {
		jQuery("#search_keywords").val("");
		jQuery("#search_keywords").attr("class", "");
	}
}

function checkSearchBox() {
	if (jQuery("#search_keywords").val() == "" || jQuery("#search_keywords").val() == "Search for Restaurants or Food") {
		jQuery("#search_keywords").val("");
		jQuery("#search_keywords").attr("class", "");
	}
}


function updateSizes() {
	var windowHeight = 0;
	
	var scrollOffset = 0;
	
	if (typeof(window.innerWidth) == 'number') {
		//Non-IE
		windowHeight = window.innerHeight;
		scrollOffset = window.pageYOffset;
	} else if(document.documentElement && document.documentElement.clientHeight) {
    	//IE 6+ in 'standards compliant mode'
		windowHeight = document.documentElement.clientHeight;
		scrollOffset = document.documentElement.scrollTop
	} else if (document.body && document.body.clientHeight) {
    	//IE 4 compatible
		windowHeight = document.body.clientHeight;		
		scrollOffset = document.body.scrollTop;
	}
		
	var mainContainerHeight = jQuery("#mainContainer").height() + 110;
	var popupHeight = jQuery("#popupContainer").height() + 40;
	
	var blockingCoverHeight = Math.max(Math.max(windowHeight, mainContainerHeight), popupHeight);
	
	jQuery("#blockingCover").height(blockingCoverHeight);
	
	var popupTop = Math.round((windowHeight - popupHeight) / 2) + scrollOffset;
	if (popupTop < 0) {
		popupTop = 0;
	}
	
	var position = jQuery("#mainContainer").position();	
	jQuery("#popupContainer").css("left", position.left);
	jQuery("#popupContainer").css("right", position.right);
	jQuery("#popupContainer").css("top", popupTop);
	jQuery("#popupContainer").css("position", "absolute");
	
	jQuery("#loadingMsg").css("left", position.left)
}


function displayPopup(focused_element) {
	popupDisplayed = true;
	
	//window.scrollTo(0, 0);
	
	new Effect.Appear(jQuery("#blockingCover").get(0), { duration: 0.3, to: 0.75 });
	
	updateSizes();
	
	new Effect.Appear(jQuery("#popupContainer").get(0), {
		duration: 0.3,
		afterFinish: function() {
			if ($("#" + focused_element) != null) {
				$("#" + focused_element).focus();
			}
		}
	});

}

function hidePopup() {
	new Effect.Fade(jQuery("#popupContainer").get(0), { duration: 0.3 });
	new Effect.Fade(jQuery("#blockingCover").get(0), { duration: 0.3 });
	
	popupDisplayed = false;
}

function displayLoadingMsg() {
	loadingDisplayed = true;

	var position = jQuery("#mainContainer").position();	
	jQuery("#loadingMsg").css("left", position.left)
	
	new Effect.Appear(jQuery("#processingCover").get(0), { duration: 0.3, to: 0.25 });
	jQuery("#loadingMsg").css("display", "block");
	
	jQuery("#ajaxCallMade").val("true");
}

function hideLoadingMsg() {
	jQuery("#loadingMsg").css("display", "none");
	new Effect.Fade(jQuery("#processingCover").get(0), { duration: 0.3 });

	loadingDisplayed = false;
}

function allowKeyPress() {
	return !loadingDisplayed && !popupDisplayed;
}


function showStatusMsg(message) {
	jQuery("#statusMsg").html(message);
	jQuery("#statusBox").css("display", "block");
}


function updateMouseLocation(e) {
	if (!e) var e = window.event;
	if (e.pageX || e.pageY) 	{
		mouseX = e.pageX;
		mouseY = e.pageY;
	}
	else if (e.clientX || e.clientY) 	{
		mouseX = e.clientX + document.body.scrollLeft
			+ document.documentElement.scrollLeft;
		mouseY = e.clientY + document.body.scrollTop
			+ document.documentElement.scrollTop;
	}
}

function checkRestaurant() {
	if (jQuery("#order_restaurant_id").val() != null && jQuery("#restaurant_id").val() != jQuery("#order_restaurant_id").val()) {
		if (confirm("You may only order from one restaurant at a time. Your cart will be emptied before adding this item. Do you wish to continue?")) {
			jQuery("#order_restaurant_id").val(jQuery("#restaurant_id").val());
		} else {
			return false;
		}
	}
	
	return true;
}


function initializeCityMap() {
  if (GBrowserIsCompatible()) {
	
	var city_count = jQuery("#city_count").val();
	
	if (!city_count) {
		return;
	}

	var city_names = jQuery("#city_names").val().split("|#|");
	var city_num_restaurants = jQuery("#city_num_restaurants").val().split("|#|");
	var city_lats = jQuery("#city_lats").val().split("|#|");
	var city_lngs = jQuery("#city_lngs").val().split("|#|");
	
    map = new GMap2(document.getElementById("map_canvas"));
	
   	map.setCenter(new GLatLng(38.4106, -95.6250), 3);
    map.setUIToDefault();
	
	for (i = 0; i < jQuery("#city_count").val(); i++) {
		marker = new GMarker(new GLatLng(city_lats[i], city_lngs[i]));
		map.addOverlay(marker);
		
		var restaurants_found = city_num_restaurants[i] + ' restaurants found ';
		if (city_num_restaurants[i] == 1) {
			restaurants_found = '1 restaurant found '
		}
		
		marker.bindInfoWindowHtml(
			'<div style="font-size:16px; font-weight: bold; margin-bottom: 10px;"><a href="/search/lookupCity?city=' + city_names[i] + '">' + city_names[i] + '</a></div>' +
			restaurants_found +
			'<b><a href="/search/lookupCity?city=' + city_names[i] + '">Show</a></b>');
	}
	
  }
}


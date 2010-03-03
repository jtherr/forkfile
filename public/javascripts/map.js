var map;
var directions;
var directionsPanel;


jQuery(document).ready(function() {
	initializeMap();
});


function initializeMap() {
  if (GBrowserIsCompatible()) {

	var user_lat = jQuery("#user_lat").val();
	var user_lng = jQuery("#user_lng").val();
	var user_address = jQuery("#user_address").val();
	
	
	var restaurant_count = jQuery("#restaurant_count").val();
	
	if (!restaurant_count) {
		showResultList();
		return;
	}

	var restaurant_names = jQuery("#restaurant_names").val().split("|#|");
	var restaurant_ids = jQuery("#restaurant_ids").val().split("|#|");
	var restaurant_addresses_formatted = jQuery("#restaurant_addresses_formatted").val().split("|#|");
	var restaurant_addresses = jQuery("#restaurant_addresses").val().split("|#|");
	var restaurant_lats = jQuery("#restaurant_lats").val().split("|#|");
	var restaurant_lngs = jQuery("#restaurant_lngs").val().split("|#|");

	
    map = new GMap2(document.getElementById("map_canvas"));
    map.setUIToDefault();
	
	if (user_lat != null && user_lng != null) {
    	map.setCenter(new GLatLng(user_lat, user_lng), 12);
	} else {
    	map.setCenter(new GLatLng(restaurant_lats[0], restaurant_lngs[0]), 12);
	}
	
	for (i = 0; i < jQuery("#restaurant_count").val(); i++) {
		marker = new GMarker(new GLatLng(restaurant_lats[i], restaurant_lngs[i]));
		map.addOverlay(marker);
		marker.bindInfoWindowHtml(
			'<b><a href="/restaurant/showRestaurant/' + restaurant_ids[i] + '">' + restaurant_names[i] + '</a></b><br>' + 
			restaurant_addresses_formatted[i] + '<br><br>' +
			'<a href="javascript:getDirections(\'' + user_address + '\',\'' + restaurant_addresses[i] + '\')">Directions</a>');
	}
	
	jQuery("#directions").css("display", "none");
  }
}


function getDirections(from, to) {
	map = new GMap2(document.getElementById("map_canvas"));
	map.addControl(new GSmallMapControl());
	map.addControl(new GMapTypeControl());
	
	directionsPanel = document.getElementById("directions_panel")
	
	jQuery("#directions_panel").empty()
	
	directions = new GDirections(map, directionsPanel);
	
	directions.load(from + " to " + to);
	
	jQuery("#directions").css("display", "block");
}


var map;
var directions;
var directionsPanel;


jQuery(document).ready(function() {
	var user_address = jQuery("#user_address").val();
	var restaurant_address = jQuery("#restaurant_address").val();

	getDirections(user_address, restaurant_address);
});

function getDirections(from, to) {
	map = new GMap2(document.getElementById("map_canvas"));
    map.setUIToDefault();
	
	directionsPanel = document.getElementById("directions_panel");
	
	jQuery("#directions_panel").empty();
	
	directions = new GDirections(map, directionsPanel);

	GEvent.addListener(directions, "error", handleError);

	directions.load("from: " + from + " to: " + to, {travelMode:G_TRAVEL_MODE_DRIVING});
		
	jQuery("#directions").css("display", "block");
}


function handleError() {
	var user_lat = jQuery("#user_lat").val();
	var user_lng = jQuery("#user_lng").val();
	var restaurant_lat = jQuery("#restaurant_lat").val();
	var restaurant_lng = jQuery("#restaurant_lng").val();
	
	var from = [user_lat, user_lng];
	var to = [restaurant_lat, restaurant_lng];
	
	directions.loadFromWaypoints([from, to]);
}

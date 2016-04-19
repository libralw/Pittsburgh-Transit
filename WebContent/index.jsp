<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1" />
<link rel="stylesheet"
	href="http://code.jquery.com/mobile/1.4.5/jquery.mobile-1.4.5.min.css" />
<script src="http://code.jquery.com/jquery-1.11.1.min.js"></script>
<script type="text/javascript"
	src="http://maps.google.com/maps/api/js?sensor=false"></script>
<script type="text/javascript"
	src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script
	src="http://code.jquery.com/mobile/1.4.5/jquery.mobile-1.4.5.min.js"></script>
<script src="js/onchange.js"></script>
<script type="text/javascript">
	var map
	var directionDisplay;
	var currLocation;
	var geocoder;
	var directionsService = new google.maps.DirectionsService();
	$(document).ready(function() {
		navigator.geolocation.getCurrentPosition(initialize);
	});

	function initialize(location) {

		currLocation = new google.maps.LatLng(location.coords.latitude,
				location.coords.longitude)

		directionsDisplay = new google.maps.DirectionsRenderer();

		geocoder = new google.maps.Geocoder();

		geocoder
				.geocode(
						{
							'latLng' : currLocation
						},
						function(results, status) {
							if (status == google.maps.GeocoderStatus.OK) {
								if (results[1]) {
									document.getElementById("start").value = results[1].formatted_address;
								} else {
									alert('No results found');
								}
							} else {
								alert('Geocoder failed due to: ' + status);
							}
						});

		var myOptions = {
			zoom : 13,
			center : currLocation,
			mapTypeId : google.maps.MapTypeId.ROADMAP,
			mapTypeControl : false
		};
		map = new google.maps.Map(document.getElementById("map_canvas"),
				myOptions);
		directionsDisplay.setMap(map);
		directionsDisplay.setPanel(document.getElementById("directionsPanel"));
		var marker = new google.maps.Marker({
			position : currLocation,
			map : map,
			title : "Current location"
		});

		$("#list_route").hide();

	}
	function calcRoute() {
		//$("#list_route").show();
		//$("#map_canvas").hide();
		//$("#directionsPanel").hide();
		showOnMap();
	}
	function showOnMap() {
		//$("#list_route").hide();
		$("#directionsPanel").show();
		var end = document.getElementById("start").value;
		var start = document.getElementById("end").value;
		if (document.getElementById("departure").value != null) {
		}
		var departureT = document.getElementById("departure").value;
		var arraivalT = document.getElementById("arrival").value;

		var request = {
			origin : start,
			destination : end,
			travelMode : google.maps.DirectionsTravelMode.TRANSIT,
			provideRouteAlternatives : true,
			transitOptions : {
			//departureTime: departureT,
			//arrivalTime: arraivalT
			},
		};
		directionsService.route(request, function(response, status) {
			if (status == google.maps.DirectionsStatus.OK) {
				directionsDisplay.setDirections(response);
				//response

			}
		});
		if (document.getElementById("showmap").checked) {
			$("#map_canvas").show();
		} else {
			$("#map_canvas").hide();
		}
	}
</script>
<style>
#realtime div.ui-input-text {
	width: 40% !important
}

#realtime label {
	width: 50% !important
}
</style>
</head>
<body>

	<div data-role="page" id="pageone" data-theme="b">
		<div data-role="header">
			<h1>Mobile Trip Assistant</h1>
		</div>
		<div data-role="content">
			<a href="#tripplanner" data-role="button" data-theme="b"
				style="min-height: 100px; line-height: 100px; font-size: 35px">Trip
				Planner</a> <a href="#realtime" data-role="button"
				style="min-height: 100px; line-height: 100px; font-size: 35px">Bus
				Arrivals</a>
		</div>


		<div data-role="footer">
			<h1></h1>
		</div>
	</div>

	<div data-role="page" id="tripplanner" data-theme="b">
		<div data-role="header">
			<a href="#" data-role="button" data-rel="back" data-icon="back">Return</a>
			<h1>Trip Planner</h1>
		</div>
		<div data-role="content">
			<form>
				<div data-role="fieldcontain">
					<label for="start">From </label> <input type="text" name="start"
						id="start" required="required"> <label for="end">to
					</label> <input type="text" name="end" id="end" required="required">
				</div>
				<div data-role="fieldcontain">
					<fieldset data-role="controlgroup" data-type="horizontal">
						<input type="radio" name="radio-choice" id="departure"
							value="choice-1" checked="checked" /> <label for="departure">Departure
							At</label> <input type="radio" name="radio-choice" id="arrival"
							value="choice-2" /> <label for="arrival">Arrival At</label>
					</fieldset>
				</div>
				<div data-role="fieldcontain">
					<label for="datetime-l">Time: </label>
					<!--<input type="datetime-local" name="datetime-l" id="datetime-l" autocomplete = "on" class="ui-input-text ui-body-c">-->
					<select name="time" id="time">
						<option value="">Now</option>
						<option value="">Today, 11 00 AM</option>
						<option value="">Today, 12 00 PM</option>
						<option value="">Today, 13 00 PM</option>
						<option value="">Today, 14 00 PM</option>
						<option value="">Today, 15 00 PM</option>
						<option value="">Today, 16 00 PM</option>
						<option value="">Today, 17 00 PM</option>
						<option value="">Today, 18 00 PM</option>
					</select>
				</div>
				<div data-role="fieldcontain">
					<select name="critic" id="critic">
						<option value="1">Quickest</option>
						<option value="2">Fewest transfers</option>
						<option value="3">Least amount of walking</option>
					</select>
				</div>
				<div data-role="fieldcontain">
					<label><input type="checkbox" name="checkbox-1"
						id="showmap" checked="checked" />Show Me the Map</label>
				</div>

				<a data-role="button" onclick="calcRoute();">Plan My Trip</a>

				<div data-role="fieldcontain">
					<div id="map_canvas" style="width: 100%; height: 300px"></div>
				</div>
				<div data-role="fieldcontain">
					<div id="directionsPanel" style="background-color: #FFF"></div>
				</div>


				<div>
					<div id="ads" style="width: 100%; height: 300px">
						<img
							src="http://img3.wikia.nocookie.net/__cb20120813003900/bttf/images/8/84/Pepsi-logo-2012-1024x398.jpg"
							style="width: 100%;" />
					</div>
				</div>
			</form>
		</div>

		<div data-role="footer">
			<h1></h1>
		</div>
	</div>

	<div data-role="page" id="realtime" data-theme="b">
		<div data-role="header">
			<a href="#" data-role="button" data-rel="back" data-icon="back">Return</a>
			<h1>Real Time Bus Stop</h1>
		</div>
		<div data-role="content">
			<form method="post" action="search.do" data-ajax="false">
				<div data-role="fieldcontain">
					<label for="name">Select Your Route: </label> <input type="text"
						name="selectRoute" id="selectRoute" />
				</div>
				<select name="routeSelect" id="routeSelect">

					<option value="1">1 - FREEPORT ROAD</option>

					<option value="12">12 - MCKNIGHT</option>

					<option value="13">13 - BELLEVUE</option>

					<option value="14">14 - OHIO VALLEY</option>

					<option value="15">15 - CHARLES</option>

					<option value="16">16 - BRIGHTON</option>

					<option value="17">17 - SHADELAND</option>

					<option value="18">18 - MANCHESTER</option>

					<option value="19L">19L - EMSWORTH LIMITED</option>

					<option value="2">2 - MOUNT ROYAL</option>

					<option value="20">20 - KENNEDY</option>

					<option value="21">21 - CORAOPOLIS</option>

					<option value="22">22 - MCCOY</option>

					<option value="24">24 - WEST PARK</option>

					<option value="26">26 - CHARTIERS</option>

					<option value="27">27 - FAIRYWOOD</option>

					<option value="28X">28X - AIRPORT FLYER</option>

					<option value="29">29 - ROBINSON</option>

					<option value="31">31 - BRIDGEVILLE</option>

					<option value="36">36 - BANKSVILLE</option>

					<option value="38">38 - GREEN TREE</option>

					<option value="39">39 - BROOKLINE</option>

					<option value="41">41 - BOWER HILL</option>

					<option value="48">48 - ARLINGTON</option>

					<option value="51">51 - CARRICK</option>

					<option value="51L">51L - CARRICK LIMITED</option>

					<option value="52L">52L - HOMEVILLE LIMITED</option>

					<option value="53">53 - HOMESTEAD PARK</option>

					<option value="53L">53L - HOMESTEAD PARK LIMITED</option>

					<option value="54">54 - NORTH SIDE-OAKLAND-SOUTH SIDE</option>

					<option value="55">55 - GLASSPORT</option>

					<option value="56">56 - LINCOLN PLACE</option>

					<option value="57">57 - HAZELWOOD</option>

					<option value="58">58 - GREENFIELD</option>

					<option value="59">59 - MON VALLEY</option>

					<option value="6">6 - SPRING HILL</option>

					<option value="60">60 - WALNUT - CRAWFORD VILLAGE</option>

					<option value="61A">61A - NORTH BRADDOCK</option>

					<option value="61B">61B - BRADDOCK-SWISSVALE</option>

					<option value="61C">61C - MCKEESPORT-HOMESTEAD</option>

					<option value="61D">61D - MURRAY</option>

					<option value="64">64 - LAWRENCEVILLE - WATERFRONT</option>

					<option value="65">65 - SQUIRREL HILL</option>

					<option value="67">67 - MONROEVILLE</option>

					<option value="68">68 - BRADDOCK HILLS</option>

					<option value="69">69 - TRAFFORD</option>

					<option value="71">71 - EDGEWOOD TOWN CENTER</option>

					<option value="71A">71A - NEGLEY</option>

					<option value="71B">71B - HIGHLAND PARK</option>

					<option value="71C">71C - POINT BREEZE</option>

					<option value="71D">71D - HAMILTON</option>

					<option value="74">74 - HOMEWOOD-SQUIRREL HILL</option>

					<option value="75">75 - ELLSWORTH</option>

					<option value="77">77 - PENN HILLS</option>

					<option value="78">78 - OAKMONT</option>

					<option value="79">79 - EAST HILLS</option>

					<option value="8">8 - PERRYSVILLE</option>

					<option value="81">81 - OAK HILL</option>

					<option value="82">82 - LINCOLN</option>

					<option value="83">83 - BEDFORD HILL</option>

					<option value="86">86 - LIBERTY</option>

					<option value="87">87 - FRIENDSHIP</option>

					<option value="88">88 - PENN</option>

					<option value="89">89 - GARFIELD COMMONS</option>

					<option value="91">91 - BUTLER STREET</option>

					<option value="93">93 - LAWRENCEVILLE - HAZELWOOD</option>

					<option value="G2">G2 - WEST BUSWAY</option>

					<option value="G3">G3 - MOON FLYER</option>

					<option value="G31">G31 - BRIDGEVILLE FLYER</option>

					<option value="O1">O1 - ROSS FLYER</option>

					<option value="O12">O12 - MCKNIGHT FLYER</option>

					<option value="O5">O5 - THOMPSON RUN FLYER</option>

					<option value="P1">P1 - EAST BUSWAY-ALL STOPS</option>

					<option value="P10">P10 - ALLEGHENY VALLEY FLYER</option>
				</select>
				<p>Select Your Direction</p>
				<select name="direction" id="direction">
					<option value="inbound">Inbound</option>
					<option value="outbound">Outbound</option>
				</select>
				<p>Select Your Stop</p>
				<select name="stopSelect" id="stopSelect">

					<option value="1171">5th Ave at Bellefield Ave</option>

					<option value="34">5th Ave at Bigelow Blvd</option>

					<option value="38">5th Ave at Chesterfield Rd</option>

					<option value="3151">5th Ave at Dinwiddie St</option>

					<option value="3156">5th Ave at Magee St</option>

					<option value="3154">5th Ave at Pride St</option>

					<option value="2640">5th Ave at Robinson St</option>

					<option value="3155">5th Ave at Stevenson St</option>

					<option value="33">5th Ave at Tennyson Ave</option>

					<option value="35">5th Ave at Thackeray Ave</option>

					<option value="3157">5th Ave at Washington Pl</option>

					<option value="20690">5th Ave at Wood St</option>

					<option value="3149">5th Ave at Wyandotte St</option>

					<option value="2644">5th Ave opp #2358</option>

					<option value="2643">5th Ave opp #2410</option>

					<option value="36" selected>5th Ave opp Atwood St</option>

					<option value="2639">5th Ave opp Craft Ave</option>

					<option value="18161">5th Ave opp Diamond St</option>

					<option value="3150">5th Ave opp Gist St</option>

					<option value="3148">5th Ave opp Seneca St</option>

					<option value="3152">5th Ave opp Van Braam St</option>

					<option value="18165">5th Ave past Brenham St</option>

					<option value="18164">5th Ave past Kirkpatrick St</option>

					<option value="3147">5th Ave past Moultrie</option>

					<option value="1509">6th Ave at Bigelow Blvd</option>

					<option value="20292">6th Ave at Center Ave</option>

					<option value="3158">6th Ave at Smithfield St</option>

					<option value="3159">6th Ave at Wood St</option>

					<option value="8275">Bryant St at Mellon St</option>

					<option value="8176">Bryant St at Negley Ave</option>

					<option value="8193">Centre Ave at Aiken Ave</option>

					<option value="8195">Centre Ave at Cypress St</option>

					<option value="8192">Centre Ave at Graham St</option>

					<option value="2632">Centre Ave at Melwood Ave</option>

					<option value="8197">Centre Ave at Millvale Ave</option>

					<option value="8196">Centre Ave at Morewood Ave</option>

					<option value="2631">Centre Ave opp Neville St</option>

					<option value="8194">Centre Ave opp Shadyside Hospital</option>

					<option value="2633">Centre Ave past Craig St</option>

					<option value="2635">Craig St at 5th Ave</option>

					<option value="2634">Craig St at Bayard St</option>

					<option value="8190">Negley Ave at #370</option>

					<option value="8182">Negley Ave at Black St</option>

					<option value="8186">Negley Ave at Broad St</option>

					<option value="8191">Negley Ave at Centre Ave</option>

					<option value="8188">Negley Ave at Coral St</option>

					<option value="8189">Negley Ave at Friendship Ave</option>

					<option value="8177">Negley Ave at Hampton St</option>

					<option value="8181">Negley Ave at Hays St</option>

					<option value="8179">Negley Ave at Jackson St</option>

					<option value="8183">Negley Ave at Margaretta St</option>

					<option value="8180">Negley Ave at Stanton Ave</option>

					<option value="8184">Negley Ave opp Rippey St (farside)</option>

					<option value="8185">Negley Ave opp Rural St</option>

					<option value="8178">Negley Ave opp Wellesley Ave</option>

					<option value="19060">Negley Ave past Penn Ave</option>

					<option value="3120">St Clair St at Bryant St</option>

					<option value="3118">St Clair St at Bunkerhill Apts</option>

					<option value="3119">St Clair St at Callowhill St</option>

				</select> <input name="action" data-ajax="false" type="submit"
					data-role="button" value="Get
					Arrival Times!">
			</form>
		</div>

		<div data-role="footer">
			<h1></h1>
		</div>
	</div>

	<div data-role="page" id="arrivals" data-theme="b">
		<div data-role="header">
			<a href="#" data-role="button" data-rel="back" data-icon="back">Return</a>
			<h1>Estimated Arrival Times</h1>
		</div>
		<div data-role="content" style="font-size: larger">
			<h2>${size}</h2>
			<c:if test="${size==null}">
				<h2>${he}</h2>
			</c:if>
			<ul data-role="listview" data-inset="true"
				class="ui-listview ui-listview-inset ui-corner-all ui-shadow"
				style="font-size: larger">
				<c:forEach var="arrival" items="${arrivalList}">
					<li data-corners="false" data-shadow="false" data-iconshadow="true"
						data-wrapperels="div" data-icon="arrow-r" data-iconpos="right"
						data-theme="c" class="ui-li-has-arrow ui-li ui-btn-up-c"><div
							class="ui-btn-inner ui-li">
							<div class="ui-btn-text">
								<p class="ui-li-aside ui-li-desc">
									<strong>${arrival.time} </strong>Minutes
								</p>
								<h2 class="ui-li-heading">${arrival.route}</h2>
							</div>
							<span class="ui-icon ui-icon-arrow-r ui-icon-shadow">&nbsp;</span>
						</div></li>
				</c:forEach>
			</ul>

		</div>
		<c:if test="${size==null}">
			<div data-role="content" style="font-size: larger">
				<a href="#map" data-role="button" data-ajax="false">Show the
					location in the map</a>
			</div>
		</c:if>

		<div data-role="footer">
			<h1></h1>
		</div>
	</div>

	<div data-role="page" id="map" data-theme="b">
		<div data-role="header">
			<a href="#" data-role="button" data-rel="back" data-icon="back">Return</a>
			<h1>Estimated Arrival Times</h1>
		</div>
		<div data-role="content" style="font-size: larger">
			<IFRAME name="map" width=100% height=800px
				src="http://truetime.portauthority.org/bustime/map/displaymap.jsp?route=71C&stopId=20690&stop=5th%20Ave%20at%20Wood%20St"></IFRAME>

		</div>
	</div>

</body>
</html>

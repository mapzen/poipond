var markers = [];
var map, lat, lng;

function checkIn() {
  var query_string = '/closest?lat=' + lat + '&lng=' + lng + '&type=poi';
  $.ajax({
    type: 'GET',
    dataType: "json",
    url: 'http://api-pelias-test.mapzen.com' + query_string,
    success: function(geoJson) {
      $('#poi-results-list').empty();
      for (key in geoJson.features) {
        if (geoJson.features.hasOwnProperty(key)) {
          obj = geoJson.features[key];
          var distance = getDistance(lat, lng, obj.geometry.coordinates[1], obj.geometry.coordinates[0]);
          $('#poi-results-list').append([
            '<a href="/pois/' + obj.properties.osm_id + '" class="list-group-item">' + obj.properties.name,
            '<br/>' + getAddress(obj) + '<br/>' + distance + ' miles</a>'
          ].join(''))
        }
      }
    }
  });
}

function onLocationFound(e) {
  var radius = e.accuracy / 2;
  for (i=0; i<markers.length; i++) {
    map.removeLayer(markers[i]);
  }
  var marker = L.circle(e.latlng, radius);
  markers.push(marker);
  marker.addTo(map);
  lat = e.latlng.lat;
  lng = e.latlng.lng;
}

function onLocationError(e) {
  console.log(e.message);
}

function getAddress(obj) {
  var address = '';
  if (obj.properties.street_name==null) {
    address = 'No address';
  }
  else {
    if (obj.properties.street_number!=null) {
      address += obj.properties.street_number + ' ';
    }
    address += obj.properties.street_name;
  }
  return address;
}

function toRad(num) {
  return num * Math.PI / 180;
}

function getDistance(lat1, lon1, lat2, lon2) {
  var unit = 3960; // miles, km=6371
  var dLat = toRad(lat2 - lat1);
  var dLon = toRad(lon2 - lon1);
  var lat1 = toRad(lat1);
  var lat2 = toRad(lat2);
  var a = Math.sin(dLat/2) * Math.sin(dLat/2) + Math.sin(dLon/2) * Math.sin(dLon/2) * Math.cos(lat1) * Math.cos(lat2);
  var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
  return (unit * c).toFixed(2);
}

$(document).ready(function() {
  map = L.mapbox.map('map', 'randyme.h29f04e6', { zoomControl: false});
  map.locate({setView: true, maxZoom: 16, watch: true, enableHighAccuracy: true});
  map.on('locationfound', onLocationFound);
  map.on('locationerror', onLocationError);
});

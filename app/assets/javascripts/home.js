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

$(document).ready(function() {
  map = L.mapbox.map('map', 'randyme.h29f04e6', { zoomControl: false });
  map.locate({ setView: true, maxZoom: 16, watch: true, enableHighAccuracy: true });
  map.on('locationfound', function (e) {
    var radius = e.accuracy / 2;
    for (i=0; i<markers.length; i++) {
      map.removeLayer(markers[i]);
    }
    var marker = L.circle(e.latlng, radius);
    markers.push(marker);
    marker.addTo(map);
    lat = e.latlng.lat;
    lng = e.latlng.lng;
  });
  map.on('locationerror', function (e) {
    console.log(e.message);
  });
});

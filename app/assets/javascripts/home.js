function checkIn() {
  $.ajax({
    type: 'GET',
    dataType: "json",
    url: 'http://poipond.com/api/v0/pois/closest?lat=' + lat + '&lon=' + lon,
    success: function(geoJson) {
      $('#poi-results-list').empty();
      for (key in geoJson) {
        if (geoJson.hasOwnProperty(key)) {
          obj = geoJson[key];
          $('#poi-results-list').append([
            '<a href="/pois/' + obj.id + '" class="list-group-item">' + obj.name,
            '<br/>' + obj.full_addr + '<br/>' + obj.distance + ' miles',
            '<img src="/assets/edit-poi.png" width="20" height="20" class="pull-right"></a>'
          ].join(''))
        }
      }
    }
  });
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
    lon = e.latlng.lng;
  });
  map.on('locationerror', function (e) {
    console.log(e.message);
  });
});

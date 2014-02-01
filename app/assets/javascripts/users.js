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

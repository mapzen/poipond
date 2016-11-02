$(document).ready(function() {
  map = L.Mapzen.map('map', {
    zoomControl:false,
    center: [40.74429, -73.99035],
    zoom: 15,
    scene: L.Mapzen.BasemapStyles.Refill
  });
  map.locate({setView: true, maxZoom: 16});
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
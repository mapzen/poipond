//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require turbolinks
//= require_tree .

$(function() {

  var markers = [];

  function onLocationFound(e) {
    var radius = e.accuracy / 2;
    for (i=0; i<markers.length; i++) {
      map.removeLayer(markers[i]);
    }
    var marker = L.circle(e.latlng, radius);
    markers.push(marker);
    marker.addTo(map);
  }

  function onLocationError(e) {
    console.log(e.message);
  }

  var map = L.mapbox.map('map', 'randyme.gajlngfe', { zoomControl: false});
  map.locate({setView: true, maxZoom: 16, watch: true, enableHighAccuracy: true});
  map.on('locationfound', onLocationFound);
  map.on('locationerror', onLocationError);

});

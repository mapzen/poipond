//= require jquery
//= require jquery_ujs
//= require bootstrap

var markers = [];
var map, lat, lng;

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

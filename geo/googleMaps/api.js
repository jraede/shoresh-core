// convert Google Maps into an AMD module
// We need to use async because it loads a bunch of other stuff
// after loading this one file and we need to wait until they're all
// ready before we run it
define(['async!//maps.google.com/maps/api/js?v=3&sensor=false'],
function(){
    return window.google.maps;
});

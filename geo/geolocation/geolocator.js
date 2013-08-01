// Generated by CoffeeScript 1.6.2
/*
 * This class runs the native geolocation methods on the browser to return
 * the user's current position, with a success and failure handler. If the
 * browser is not compatible, it runs the fail handler right away
 *
 * @author  Jason Raede
*/


(function() {
  define([], function() {
    var Geolocator;

    return Geolocator = (function() {
      function Geolocator() {}

      Geolocator.run = function(success, fail) {
        if (this.compatible) {
          return navigator.geolocation.getCurrentPosition(success, fail);
        } else if (typeof fail === 'function') {
          return fail();
        }
      };

      Geolocator.compatible = function() {
        if (navigator && navigator.geolocation && typeof navigator.geolocation.getCurrentPosition === 'function') {
          return true;
        }
        return false;
      };

      return Geolocator;

    })();
  });

}).call(this);

// Generated by CoffeeScript 1.6.2
(function() {
  define(['components/geo/googleMaps/api'], function(GoogleMaps) {
    var GoogleMapsDirections;

    return GoogleMapsDirections = (function() {
      function GoogleMapsDirections() {}

      GoogleMapsDirections.getDirectionsRenderer = function() {
        if (!this.directionsRenderer) {
          this.directionsRenderer = new GoogleMaps.DirectionsRenderer();
        }
        return this.directionsRenderer;
      };

      GoogleMapsDirections.getDirectionsService = function() {
        if (!this.directionsService) {
          this.directionsService = new GoogleMaps.DirectionsService();
        }
        return this.directionsService;
      };

      GoogleMapsDirections.getDirections = function(map, panel, origin, destination, travelMode, error) {
        var request,
          _this = this;

        travelMode = this.parseTravelMode(travelMode);
        this.getDirectionsRenderer().setMap(map);
        this.getDirectionsRenderer().setPanel(document.getElementById(panel));
        request = {
          origin: origin,
          destination: destination,
          travelMode: travelMode
        };
        return this.getDirectionsService().route(request, function(result, status) {
          if (status === GoogleMaps.DirectionsStatus.OK) {
            return _this.getDirectionsRenderer().setDirections(result);
          } else {
            switch (status) {
              case GoogleMaps.DirectionsStatus.ZERO_RESULTS:
                'NO_RESULTS';
                break;
              case GoogleMaps.DirectionsStatus.NOT_FOUND:
                'NOT_FOUND';
                break;
              case GoogleMaps.DirectionsStatus.OVER_QUERY_LIMIT:
                'OVER_QUERY_LIMIT';
                break;
              case GoogleMaps.DirectionsStatus.REQUEST_DENIED:
                'REQUEST_DENIED';
            }
            return error(status);
          }
        });
      };

      GoogleMapsDirections.parseTravelMode = function(travelMode) {
        var mode;

        return mode = (function() {
          switch (travelMode) {
            case 'walking':
              return GoogleMaps.TravelMode.WALKING;
            case 'bicycling':
              return GoogleMaps.TravelMode.BICYCLING;
            case 'transit':
              return GoogleMaps.TravelMode.TRANSIT;
            default:
              return GoogleMaps.TravelMode.DRIVING;
          }
        })();
      };

      return GoogleMapsDirections;

    })();
  });

}).call(this);

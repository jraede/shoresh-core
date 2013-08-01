define ['core/geo/googleMaps/api'], (GoogleMaps) ->
	class GoogleMapsDirections 
		@getDirectionsRenderer: ->
			if !@directionsRenderer then @directionsRenderer = new GoogleMaps.DirectionsRenderer()

			return @directionsRenderer

		@getDirectionsService: ->
			if !@directionsService then @directionsService = new GoogleMaps.DirectionsService()

			return @directionsService

		@getDirections: (map, panel, origin, destination, travelMode, error) ->
			travelMode = @parseTravelMode(travelMode)

			@getDirectionsRenderer().setMap map
			@getDirectionsRenderer().setPanel document.getElementById(panel)

			request = 
				origin:origin
				destination:destination
				travelMode:travelMode

			@getDirectionsService().route request, (result, status) =>
				if status is GoogleMaps.DirectionsStatus.OK
					@getDirectionsRenderer().setDirections(result)
				else 
					switch status
						when GoogleMaps.DirectionsStatus.ZERO_RESULTS then 'NO_RESULTS'
						when GoogleMaps.DirectionsStatus.NOT_FOUND then 'NOT_FOUND'
						when GoogleMaps.DirectionsStatus.OVER_QUERY_LIMIT then 'OVER_QUERY_LIMIT'
						when GoogleMaps.DirectionsStatus.REQUEST_DENIED then 'REQUEST_DENIED'
					error(status)

		@parseTravelMode: (travelMode) ->
			mode = switch travelMode			
				when 'walking' then GoogleMaps.TravelMode.WALKING
				when 'bicycling' then GoogleMaps.TravelMode.BICYCLING
				when 'transit' then GoogleMaps.TravelMode.TRANSIT
				else  GoogleMaps.TravelMode.DRIVING
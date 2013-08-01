define ['jquery', 'core/geo/googleMaps/api'], ($, GoogleMaps) ->
	class GoogleMap 

		defaultParams:
			center: 
				latitude:'34.43036357495847'
				longitude:'-119.76904392242432'
				address:''
			zoom:4
			fitToPoints:false
			geolocate:
				geolocate:false
				marker:
					show:false
					image:false
				
			markers:null
			mapType:'hybrid'
			controls: 
				pan:
					show:false
					position:'top right'
				zoom:
					show:true
					style:'default'
					position:'left center'
				mapType:
					show:true
					style:'default'
					position:'bottom center'
				scale:
					show:false
					position:'top left'				
				streetView:
					show:false,
					position:'left top'
			events:
				click:false
				dblclick:false
				mouseup:false
				mousedown:false
				mouseover:false
				mouseout:false		
			places:
				search:false
				center:false
				radius:false
				searchBox:false
				placeChanged:
					action:false
					zoom:7


		constructor:(el, params) ->
			@element = el
			@geocoder = new GoogleMaps.Geocoder()
			@drawMap(params)

			

		drawMap: (params) ->
			mapConfig =
				mapTypeId:false
				zoom:false
				panControl:false
				panControlOptions: 
					position:false
				mapTypeControl:false
				mapTypeControlOptions: 
					position:false
					style:false
				zoomControl:false
				zoomControlOptions: 
					position:false
					style:false
				scaleControl:false
				scaleControlOptions: 
					position:false
				streetViewControl:false
				streetViewControlOptions: 
					position:false
			
			@params = $.extend({}, @defaultParams, params)

			# Update the configuration with the relevant parameters
			mapConfig.mapTypeId = @parseType(@params.mapType)
			mapConfig.zoom = @params.zoom

			if @params.controls.pan
				mapConfig.panControl = @params.controls.pan.show
				mapConfig.panControlOptions.position = @parseControlPosition(@params.controls.pan.position)
		
			
			if @params.controls.mapType
				mapConfig.mapTypeControl = @params.controls.mapType.show
				mapConfig.mapTypeControlOptions.position = @parseControlPosition(@params.controls.mapType.position)
				mapConfig.mapTypeControlOptions.style = @parseTypeControlStyle(@params.controls.mapType.style)
			
			if @params.controls.zoom
				mapConfig.zoomControl = @params.controls.zoom.show
				mapConfig.zoomControlOptions.position = @parseControlPosition(@params.controls.zoom.position)
				mapConfig.zoomControlOptions.style = @parseZoomControlStyle(@params.controls.zoom.style)

			if @params.controls.scale
				mapConfig.scaleControl = @params.controls.scale.show
				mapConfig.scaleControlOptions.position = @parseControlPosition(@params.controls.scale.position)

			if @params.controls.streetView
				mapConfig.streetViewControl = @params.controls.streetView.show
				mapConfig.streetViewControlOptions.position = @parseControlPosition(@params.controls.streetView.position)
			
			###
			 * Now generate the map
			###
			@map = new GoogleMaps.Map(@element, mapConfig)

			
			# Set the center
			if @params.center.address
				@geocode @params.center.address, (results) =>
					@map.setCenter(results[0].geometry.location)

			else
				@map.setCenter(@parsePoint(@params.center.latitude, @params.center.longitude))
				
				
			
			# Add listeners
			if typeof @params.onClick is 'function'
				GoogleMaps.event.addListener @map, 'click', (event) =>
					@params.onClick(event)

			@points = []
			@markers = []

			# Now add the markers
			@parseMarkers()

			###
			GoogleMaps.event.addListener(this.map, 'bounds_changed', function() {
        		self.bounds = self.map.getBounds();
        	
	      	});
	      	###
			
			
			# Do places search with google places API
			@parsePlaces()
		

		parsePlaces: ->

		parseMarkers: () ->
			markers = @params.markers
			console.log markers
			if !markers then return
			for marker in markers
				if marker.latitude and marker.longitude
					position = @parsePoint(marker.latitude, marker.longitude)
					marker.position = position
					@points.push(position)
					@initMarker(marker)
				else if marker.address
					# Geocode it
					@geocodeAndAddMarker(marker)
	
		addMarker: (marker) ->
			return @initMarker(marker)
		geocodeAndAddMarker: (markerConfig) ->
			console.log 'geociding and adding marker'
			@geocode markerConfig.address, (results) =>
				position = results[0].geometry.location
				markerConfig.position = position
				@points.push(position)
				@initMarker(markerConfig)
		initMarker: (markerConfig, centerMapOnMarker) ->
			marker = new GoogleMaps.Marker(@parseMarkerConfig(markerConfig))
			marker.position = markerConfig.position
			marker.onClick = markerConfig.onClick
			marker.onMouseOver = markerConfig.onMouseOver
			marker.onMouseOut = markerConfig.onMouseOut
			marker.onDoubleClick = markerConfig.onDoubleClick
			marker.onMouseUp = markerConfig.onMouseUp
			marker.onMouseDown = markerConfig.onMouseDown
			
			marker.map = @map


			###
			 * Make the info window popup thing
			###
			if markerConfig.info
				marker.infoWindow = new GoogleMaps.InfoWindow
					content:markerConfig.info.html

				marker.infoWindow.onClose = markerConfig.info.onClose
				GoogleMaps.event.addListener marker, 'click', ->
					@infoWindow.open(@map, @)


				if markerConfig.info.autoOpen is true
					marker.infoWindow.open(@map, marker)

				if typeof markerConfig.info.onClose is 'function'
					GoogleMaps.event.addListener marker.infoWindow, 'closeclick', ->
						@onClose()

			# Bind the marker listeners
			if typeof marker.onMouseOver is 'function'
				GoogleMaps.event.addListener marker, 'mouseover', ->
					@onMouseOver()
			if typeof marker.onMouseOut is 'function'
				GoogleMaps.event.addListener marker, 'mouseout', ->
					@onMouseOut()
			if typeof marker.onClick is 'function'
				GoogleMaps.event.addListener marker, 'click', ->
					@onClick()
			if typeof marker.onDoubleClick is 'function'
				GoogleMaps.event.addListener marker, 'dblclick', ->
					@onDoubleClick()
			if typeof marker.onMouseUp is 'function'
				GoogleMaps.event.addListener marker, 'mouseup', ->
					@onMouseUp()
			if typeof marker.onMouseDown is 'function'
				GoogleMaps.event.addListener marker, 'mousedown', ->
					@onMouseDown


			if @params.fitToPoints
				@adjustBoundsToFitPoints()

			if centerMapOnMarker
				@map.setCenter(marker.position)

			@markers.push(marker)

			return marker

		adjustBoundsToFitPoints: ->
			if @points.length <= 1
				@map.setCenter @points[0]
				@map.setZoom 14
			else
				latlngbounds = new GoogleMaps.LatLngBounds()
				for point in @points
					latlngbounds.extend point
				@map.fitBounds(latlngbounds)
		

		parseMarkerConfig: (markerConfig) ->
			gmapMarker = 
				map: @map
				position:markerConfig.position
				draggable:markerConfig.draggable
				icon:markerConfig.image
			if markerConfig.shadow
				gmapMarker.shadow = markerConfig.shadow
			
			gmapMarker.animation = @parseMarkerAnimation(markerConfig.animation);
		
			return gmapMarker


		geocode: (address, success) ->
			@geocoder.geocode
				address:address
			, success

		###
		UTILITY METHODS. These translate normal text into Google constants
		###
		parsePoint: (latitude, longitude) ->
			return new GoogleMaps.LatLng(latitude, longitude);

		parseType: (type) ->
			switch type
				when 'satellite'
					gmapType = GoogleMaps.MapTypeId.SATELLITE
				when 'hybrid'
					gmapType = GoogleMaps.MapTypeId.HYBRID
				when 'terrain'
					gmapType = GoogleMaps.MapTypeId.TERRAIN
				else
					gmapType = GoogleMaps.MapTypeId.ROADMAP
			return gmapType

		parseZoomControlStyle: (style) ->
			switch style
				when 'small'
					styleType = GoogleMaps.ZoomControlStyle.SMALL
				when 'large'
					styleType = GoogleMaps.ZoomControlStyle.LARGE
				else
					styleType = GoogleMaps.ZoomControlStyle.DEFAULT
			return styleType

		parseTypeControlStyle: (style) ->
			switch style
				when 'horizontal bar'
					styleType = GoogleMaps.MapTypeControlStyle.HORIZONTAL_BAR
				when 'dropdown menu'
					styleType = GoogleMaps.MapTypeControlStyle.DROPDOWN_MENU
				else
					styleType = GoogleMaps.MapTypeControlStyle.DEFAULT

			return styleType


		parseControlPosition: (position) ->
			switch position
				when 'top right'
					positionReturn = GoogleMaps.ControlPosition.TOP_RIGHT
				when 'top center'
					positionReturn = GoogleMaps.ControlPosition.TOP_CENTER
				when 'top left'
					positionReturn = GoogleMaps.ControlPosition.TOP_LEFT
				when 'left top'
					positionReturn = GoogleMaps.ControlPosition.LEFT_TOP
				when 'left center'
					positionReturn = GoogleMaps.ControlPosition.LEFT_CENTER
				when 'left bottom'
					positionReturn = GoogleMaps.ControlPosition.LEFT_BOTTOM
				when 'bottom left'
					positionReturn = GoogleMaps.ControlPosition.BOTTOM_LEFT
				when 'bottom center'
					positionReturn = GoogleMaps.ControlPosition.BOTTOM_CENTER
				when 'bottom right'
					positionReturn = GoogleMaps.ControlPosition.BOTTOM_RIGHT
				when 'right bottom'
					positionReturn = GoogleMaps.ControlPosition.RIGHT_BOTTOM
				when 'right center'
					positionReturn = GoogleMaps.ControlPosition.RIGHT_CENTER
				when 'right top'
					positionReturn = GoogleMaps.ControlPosition.RIGHT_TOP

			return positionReturn

		parseMarkerAnimation: (animation) ->
			switch animation
				when 'drop'
					markerAnimation = GoogleMaps.Animation.DROP
				when 'bounce'
					markerAnimation = GoogleMaps.Animation.BOUNCE
				else
					markerAnimation = false
			return markerAnimation
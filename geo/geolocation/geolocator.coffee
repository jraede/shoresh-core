###
 * This class runs the native geolocation methods on the browser to return
 * the user's current position, with a success and failure handler. If the
 * browser is not compatible, it runs the fail handler right away
 *
 * @author  Jason Raede 
###
define [], ->
	class Geolocator
		@run: (success, fail)->
			if @compatible
				navigator.geolocation.getCurrentPosition(success, fail);
			else if typeof fail is 'function'
				fail()
		@compatible: ->
			if navigator and navigator.geolocation and typeof (navigator.geolocation.getCurrentPosition) is 'function'
				return true
			return false
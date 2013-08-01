###
 * This class just adds a CSRF token to all AJAX requests to prevent
 * CSRF attacks. The presence of this token means that as long as it 
 * isn't discovered by an attacker (IE, it isn't sniffed somehow), we can 
 * prevent attackers from tricking the user into submitting
 * a form, etc.
 *
 * The only way an attacker can take advantage of the user's session, which 
 * marks them as logged in, is via a form. This prevents that.
 *
 * Your API endpoint needs to provide a JSON response with a "token" property, 
 * which will then be sent along with every subsequent AJAX request as part
 * of the URL query string (http://myapi.com/endpoint/?token=xyz)
 * 
 * @author Jason Raede
###

define ['jquery'], ($) ->
	class CSRF

		###
		 * @var {string} The server URL that handles authorization
		###
		endpoint: null


		###
		 * The authorization token received from the server
		###
		token:null

		constructor: (endpoint) ->
			@endpoint = endpoint


		###
		 * Get a CSRF token from a server
		 * 		
		###
		request: (options)->
			success = options.success
			invalid = options.invalid
			error = options.error
			$.ajax
				type:'GET'
				url: @endpoint
				dataType:'json'
				success: (response) =>
					if response.token
						@token = response.token

						@bindSubsequentAjaxMethods()

						if success then success(response)
					else if invalid
						__.log 'doing invalid'
						invalid(response)
				error: (xhr) =>

					if error then error(xhr)

		bindSubsequentAjaxMethods: ->
			$(document).ajaxSend (event, jqxhr, settings) =>
				# Add the api key to the url
				if settings.url.indexOf('?') >= 0
					settings.url += '&token=' + @token
				else
					settings.url += '?token=' + @token



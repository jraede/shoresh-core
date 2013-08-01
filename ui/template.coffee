###
 * This class handles the loading of template files for use with
 * underscores templating engine. It stores them in a cache
 * so they are only loaded once per page load (and you can
 * also specify browser caching on the server-end to increase
 * load time)
 *
 * You can set the templateFormat method to be whatever you want
 *
 * @author  Jason Raede
 * @package  Shoresh
 * @subpackage  UI
###

define ['jquery','underscore'], ($, _) ->
	class Template 
		@currentlyLoading:[]
		@templateFormat: (template) ->
			if window.shoreshConfig and window.shoreshConfig.templateFormat
				return window.shoreshConfig.templateFormat(template)

			return '/includes/templates/' + template + '.php'
		@currentlyLoadingCallbacks:{}

		@load: (template,callback) ->
			view = @cache[template]
			if view
				return callback(view)
			else if @currentlyLoading.indexOf(template) >= 0
				@currentlyLoadingCallbacks[template].push(callback)
			else
				@currentlyLoading.push(template)
				@currentlyLoadingCallbacks[template] = []
				$.get @templateFormat(template), (view) =>
					@cache[template] = view

					for queuedCallback in @currentlyLoadingCallbacks[template]
						queuedCallback(view)

					index = @currentlyLoading.indexOf(template)
					@currentlyLoading.splice(index, 1)
					@currentlyLoadingCallbacks[template] = []

					return callback(view)
		@cache:{}

		
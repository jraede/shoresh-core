###
 * This class handles the loading of template files for use with
 * underscores templating engine. It stores them in a cache
 * so they are only loaded once per page load, and you can
 * also specify browser caching on the server-end to increase
 * load time. Or, better, you can bootstrap templates in the initial
 * page load and this class will load them all automatically
 *
 * You can set the templateFormat method to be whatever you want
 *
 * @author  Jason Raede
 * @package  Shoresh Core
 * @subpackage  UI
###

define ['jquery','underscore'], ($, _) ->
	class Template 
		###
		 * Load all scripts with data-template properties into the cache
		 * so we don't need to look each time with jquery and slow things down
		###
		@init: ->
			$ =>
				self = @
				$('script[data-template]').each ->
					template = $(@).attr('data-template')
					self.cache[template] = $(@).html()
		@cache:{}
		@currentlyLoading:[]
		@templateFormat: (template) ->
			if window.shoreshConfig and window.shoreshConfig.templateFormat
				return window.shoreshConfig.templateFormat(template)

			return '/includes/templates/' + template + '.php'
		@currentlyLoadingCallbacks:{}

		@load: (template,callback) ->
			view = @cache[template]
			if view
				callback(view)
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

					callback(view)

		
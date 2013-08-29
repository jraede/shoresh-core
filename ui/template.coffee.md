core/ui/template
===

**Package**: Shoresh

**Subpackage**: Core

**Author**: Jason Raede <jason.raede@gmail.com>

This class handles the loading of template files for use with underscore's template engine. You can either load them via AJAX on an as-needed basis, or (recommended) bootstrap them onto your pages so there is no wait time before they are loaded. All templates are stored in a cache so they are only loaded a maximum of one time per page load

If you do serve them dynamically via AJAX, it is recommended to also set some sort of browser caching header on the files or whatever you use to serve them to speed up the process.

---


	define ['jquery','underscore'], ($, _) ->
		class Template 

Here we load all bootstrapped templates into the cache so we don't have to look each time with jQuery and slow things down.

			@init: ->
				$ =>
					self = @
					$('script[data-template]').each ->
						template = $(@).attr('data-template')
						self.cache[template] = $(@).html()
			@cache:{}

If you try to load a template that is in this `currentlyLoading` array, the specified callback will just be added to the stack (no need to load the template twice).

			@currentlyLoading:[]
			@currentlyLoadingCallbacks:{}

You can set the `templateFormat` option on `window.shoreshConfig` to whatever you want; it is used to generate the full URLs for loading named templates.

			@templateFormat: (template) ->
				if window.shoreshConfig and window.shoreshConfig.templateFormat
					return window.shoreshConfig.templateFormat(template)

				return '/includes/templates/' + template + '.php'

This is the only method you will use. Here you load a template, and either retrieve it from the cache or load it by using the URL generated when passing the `template` variable to the `templateFormat` method above. If a template is in the middle of being loaded, just add the specified `callback` to the stack, and then run all callbacks for that template in order once it has been loaded.

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

Run `init` only the first time this script is required in.

		Template.init()

		
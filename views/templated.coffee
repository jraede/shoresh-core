define ['backbone', 'core/ui/template'], (Backbone, Template) ->

	class TemplatedView extends Backbone.View
		setup: ->
			# Override this with custom setup
		render: (callback) ->
			@$el.empty()
			Template.load @options.template, (view) =>
				try
					if @model
						@$el.html _.template view, @model.toTemplate()
					else
						@$el.html _.template view, @options.templateAttributes
				catch error
					error.type = 'template'
					error.info =
						template:@options.template
					window.shoreshConfig.handleError(error)

				@delegateEvents()
				@setup()

				if callback and typeof(callback) is 'function' then callback()

			return @

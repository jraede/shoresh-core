define ['backbone', 'core/ui/template'], (Backbone, Template) ->
	class TemplatedView extends Backbone.View
		setup: ->
			# Override this with custom setup
		render: (callback) ->
			@$el.empty()
			Template.load @options.template, (view) =>
				if @model
					@$el.html _.template view, @model.toTemplate()
				else
					@$el.html _.template view, @options.templateAttributes

				@delegateEvents()
				@setup()

				if callback and typeof(callback) is 'function' then callback()

			return @

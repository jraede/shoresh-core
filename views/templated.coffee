define ['backbone', 'core/ui/template'], (Backbone, Template) ->
	class TemplatedView extends Backbone.View
		setup: ->
			# Override this with custom setup
		render: (callback) ->
			@$el.empty()
			_log.info 'TEMPLATE:', @options.template
			_log.info 'Making template:', @model.toTemplate()
			Template.load @options.template, (view) =>
				if @model
					@$el.html _.template view, @model.toTemplate()
				else
					@$el.html _.template view, @options.templateAttributes

				@setup()

				if callback and typeof(callback) is 'function' then callback()

			return @

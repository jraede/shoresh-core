define ['backbone', 'core/ui/template'], (Backbone, Template) ->
	class TemplatedView extends Backbone.View
		template:null
		templateAttributes:null
		setup: ->
			# Override this with custom setup
		render: (callback) ->
			@$el.empty()
			
			Template.load @template, (view) =>
				if @model
					@$el.html _.template view, @model.toTemplate()
				else
					@$el.html _.template view, @templateAttributes

				@setup()

				if callback then callback()

			return @$el

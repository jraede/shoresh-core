define ['backbone'], (Backbone) ->
	class ShoreshModel extends Backbone.Model
		# Override this with whatever you want to pass to templates for this model
		toTemplate: ->
			return @attributes
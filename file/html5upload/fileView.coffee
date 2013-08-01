define ['jquery', 'backbone'], ($, Backbone) ->
	class UploadFileView extends Backbone.View
		tagName:'li'
		progress: (percentage) ->
		complete: (data) ->
		canceled: ->
		error: (error, exception) ->

		render: ->
		file:null

		setFile:(file) ->
			@file = file
			@file.setView(@)




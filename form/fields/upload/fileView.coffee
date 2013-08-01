define ['jquery', 'components/file/html5upload/fileView'], ($, FileView) ->
	class SettingsFileView extends FileView
		tagName:'li'
		className:'file-upload'
		initialize: ->
			@listenTo @model, 'change:progress', @progress
			@listenTo @model, 'change:status', @checkStatus
			@listenTo @model, 'destroy', @remove

		render: ->
			@$el.css('position', 'relative')
			$('<span/>').html(@model.get('name')).appendTo(@$el)
			progress = $('<div/>').addClass('progress').appendTo(@$el)
			@bar = $('<div/>').addClass('progress-bar').appendTo(progress)

			# Add the remove button
			$('<button/>').addClass('btn btn-danger btn-small').html('X').appendTo(@$el).click (e) =>
				e.preventDefault()
				@model.destroy()


		progress: (model, percent) ->
			totalWidth = @$el.outerWidth()
			@bar.css('width', percent + '%')

		checkStatus: (model, status) ->
			if status is 'complete'
				setTimeout =>					
					@bar.attr('class', 'progress-bar progress-bar-success')
				, 1000
			else if status is 'error'
				@bar.attr('class', 'progress-bar progress-bar-error')
				switch @model.get('error')
					when 400
						@$el.addClass('error').children('span').html("File type not allowed.")
					else
						@$el.addClass('error').children('span').html("Error - please try again.")
						
				
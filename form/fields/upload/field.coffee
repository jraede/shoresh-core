define ['components/form/field', 'components/form/fields/upload/fileCollectionView', 'components/file/html5upload/uploader'], (Field, FileCollectionView, Uploader) ->
	class Upload extends Field
		render: ->
			label = $('<label/>').html(@options.label).appendTo @$el
			input = $('<input type="file"/>').appendTo @$el

			if @options.help
				$('<p class="help-block"/>').html(@options.help).insertAfter input
			@postRender()

			return @$el
		postRender: ->
			fileInput = @$('input[type="file"]')
			@collectionView = new FileCollectionView
				el:@el
				config:@options.config

			uploader = new Uploader fileInput, @options.config, @collectionView

			uploader.init()

		getValue: ->
			value = []
			@collectionView.collection.each (file) ->
				if file.get('status') is 'complete'
					value.push file.get('response')

			return value
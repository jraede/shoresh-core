define ['core/file/html5upload/fileCollectionView', 'core/form/fields/upload/fileView'], (FileCollectionView, FileView) ->
	class FormFileCollectionView extends FileCollectionView
		tagName:'div'

		render: ->
			super

			@listenTo @collection, 'change:status', @updateUI
			@listenTo @collection, 'remove', @updateUI
			# add all of the UI components

			

			@fileContainer = $('<ul/>').addClass('upload-file-container').appendTo @$el
			buttonGroup = $('<div class="btn-group"/>').appendTo @$el
			@chooseFileButton = $('<button/>').addClass('choose btn btn-default').html('<i class="icon-file"></i> Choose File(s)').click (e) =>
				e.preventDefault()
				@showDialog()
			.appendTo buttonGroup

			if !@options.config.autoUpload
				@uploadButton  = $('<button/>').addClass('upload btn btn-default').html('<i class="icon-upload"></i> Upload').attr('disabled', 'disabled').click (e) =>
					e.preventDefault()
					@collection.upload()
				.appendTo buttonGroup
			@messageContainer = $('<div/>').insertBefore(@fileContainer)
		
		# This is bound by the super class (FileCollectionView) and is called
		# when a file gets added to the collection
		addFile: (file) ->
			@updateUI()

			file.view = new FileView
				model:file

			file.view.render()
			file.view.$el.appendTo(@fileContainer)
			@fileContainer.show()

		updateUI: ->
			# If the total + 1 is equal to max, hide the choose file button
			if @options.config.max > 0 and @collection.length is @options.config.max
				@chooseFileButton.attr('disabled', 'disabled')
			else
				@chooseFileButton.attr('disabled', false)

			if !@options.config.autoUpload and @collection.pendingCount()
				@uploadButton.attr('disabled', false)
			else
				@uploadButton.attr('disabled', 'disabled')
			
		showError: (error) ->
			p = $('<p class="alert alert-danger"/>').hide().html(error).prependTo(@messageContainer).slideDown 100, ->
				setTimeout =>
					p.slideUp 100, ->
						p.remove()
				, 2000
			

		invalidType: ->
			@showError('Invalid file type!')
		tooManyFiles: ->
			@showError('Error: too many files! (Max is ' + @options.config.max + ')')




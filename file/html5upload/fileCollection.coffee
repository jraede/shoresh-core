define ['backbone', 'components/file/html5upload/file'], (Backbone, FileModel) ->
	class FileCollection extends Backbone.Collection
		model:FileModel
		
		totalFiles: ->
			return @where
				status:'pending'
			.length + @where
				status:'complete'
			.length

		pendingCount: ->
			return @where
				status:'pending'
			.length
		setup: (options)->


			@element.get(0).uploader = @
			@element.css('height', '0px').css('width', '0px').attr('multiple', 'multiple').change ->
				files = @files
				console.log 'PARAMS:', @uploader.params.max, files.length, 'total files', @uploader.totalFiles()
				if  @uploader.params.max and (files.length + @uploader.totalFiles()) > @uploader.params.max
					@uploader.trigger('tooManyFiles')
				else
					for file in files
						# Check the file type
						type = file.type
						if @uploader.params.validTypes and @uploader.params.validTypes.indexOf(type) < 0
							@uploader.trigger('invalidType')
						else
							fileObject = new FileModel
								file:file
							@uploader.add(fileObject)
							

							if @uploader.params.autoUpload
								fileObject.upload()
							
					@value = ''

		showDialog: ->
			@element.trigger('click')
		upload: ->
			@each (file) ->
				file.upload()
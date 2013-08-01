define ['jquery', 'backbone'], ($, Backbone) ->
	class UploadFile extends Backbone.Model

		defaults:
			status:'pending'
			file:null
			name:null
			size:null
			type:null

		
		initialize: ->
			if @get('file')
				file = @get('file')
				if !file.size > (1024*1024)
					@size = (Math.round(file.size * 100 / (1024*1024)) / 100).toString() + 'MB'
				else
					@size = (Math.round(file.size * 100 / 1024) / 100).toString() + 'KB'


				@set('name', file.name)
				@set('type', file.type)
				@set('size', file.size)
				


			if @get('status') is 'complete'
				@set('progress', 100.0)
			else
				@set('progress', 0.0)

			super
		upload: ->
			if @get('status') is 'complete'
				return
			if !@get('file')
				alert('Cannot upload with no file')
			@set('status', 'uploading')
			xhr = new XMLHttpRequest()
			if xhr.upload
				xhr.upload.addEventListener 'progress', (event) =>
					@progress(event)
				, false
			xhr.addEventListener 'error', (error, exception) =>
				@error(error, exception)
			, false
			xhr.addEventListener 'abort', =>
				@canceled()
			, false
			xhr.addEventListener 'load', (data) =>
				@complete($.parseJSON(xhr.responseText), xhr.status)
			, false
			xhr.open('POST', @collection.params.url)
			xhr.setRequestHeader 'X_FILENAME', @get('name')
			xhr.send(@get('file'))

		progress: (event) ->
			if event.lengthComputable
				percentComplete = Math.round(event.loaded * 100 / event.total)
				@set('progress', percentComplete)
		complete: (response, status) ->
			if status is 200 or status is 201
				@set('response', response)
				@set('status', 'complete')
			else
				@set('error', status)
				@set('status', 'error')
				
			

		canceled: ->
			@set('status', 'canceled')

		error: (error, exception) ->
			@set('status', 'error')
			@set('error', error)
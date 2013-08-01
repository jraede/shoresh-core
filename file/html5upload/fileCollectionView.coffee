define ['components/file/html5upload/fileCollection', 'backbone'], (FileCollection, Backbone) ->
	class FileCollectionView extends Backbone.View
			


		render: ->
			super
			@listenTo @collection, 'add', @addFile
			@listenTo @collection, 'invalidType', @invalidType
			@listenTo @collection, 'tooManyFiles', @tooManyFiles
		addFile: (file) ->

		removeFile: (file) ->

		invalidType: ->

		tooManyFiles: ->

		showDialog: (e) ->
			if e then e.preventDefault()
			@collection.showDialog()
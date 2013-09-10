define ['backbone', 'core/views/modelRow'], (Backbone, TableRowView) ->
	class CollectionView extends Backbone.View
		initialize: ->
			@listenTo(@collection, 'add', @addNew)
			#@listenTo(@collection, 'sync', @render)
			#@listenTo(@collection, 'remove', @render)
		idPrefix:'obj-'
		modelView:TableRowView
		addNew: (obj) ->

			view = new @modelView
				model: obj
				tagName: 'tr'
				id:@idPrefix+ obj.get('id')
			if !view.template
				view.options.template = @options.modelTemplate

			index = @collection.indexOf(obj)
			before = @$('tr:eq(' + index.toString() + ')')
			if before.length
				before.before view.render().el
			else
				@$el.append view.render().el

		render: ->
			_log.info 'got sync event and rendering'
			@$el.empty()
			@collection.each (obj) =>
				@addNew(obj)
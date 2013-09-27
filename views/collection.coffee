define ['backbone', 'core/views/modelRow'], (Backbone, TableRowView) ->
	class CollectionView extends Backbone.View
		initialize: ->
			@listenTo(@collection, 'add', @addNew)
			@listenTo(@collection, 'sync', @render)
			#@listenTo(@collection, 'remove', @render)
		idPrefix:'obj-'
		modelView:TableRowView
		addNew: (obj) ->

			options = 
				model:obj
				tagName:'div'
				className:'tr'
				id:@idPrefix+obj.get('id')

			if @options.modelViewConfig
				options = _.extend(options, @options.modelViewConfig)
			view = new @modelView options
			
			if !view.template
				view.options.template = @options.modelTemplate

			index = @collection.indexOf(obj)
			before = @$('.tr:eq(' + index.toString() + ')')
			if before.length
				before.before view.render().el
			else
				@$el.append view.render().el

		render: ->
			_log.info 'RENDERING:', @collection.models
			@$el.empty()
			@collection.each (obj) =>
				@addNew(obj)
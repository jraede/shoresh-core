This view facilitates reordering of the collection by clicking on elements with class `order-by` and attribute `data-column`. 
The collection itself must implement the actual sorting; this view merely sets the comparator on the collection
and then calls the `sort` method.

	define ['backbone', 'core/views/modelRow', 'moment'], (Backbone, TableRowView, moment) ->
		class OrderableCollectionView extends Backbone.View
			initialize: ->
				@listenTo(@collection, 'add', @addNew)
				@listenTo(@collection, 'sync', @render)
				@listenTo(@collection, 'sort', @render)


			events:
				'click .order-by':'changeOrder'

			changeOrder:(e) ->
				_log.info 'changing order!'
				e.preventDefault()
				column = $(e.currentTarget).attr('data-column')
				isDate = $(e.currentTarget).attr('data-is-date')

				# If it's already sorting by that column, just change the direction
				if @collection.sortColumn is column
					currentDirection = @collection.sortDirection

					direction = if currentDirection is 'ASC' then 'DESC' else 'ASC'
				# Otherwise just change the sorting
				else
					direction = 'ASC'

				@collection.sortDirection = direction
				@collection.sortColumn = column

				# Update the links
				@$('.order-by i').remove()
				if direction is 'ASC'
					@$('.order-by[data-column="' + column + '"]').append('<i style="margin-left:10px;" class="icon-long-arrow-up"></i>')
				else
					@$('.order-by[data-column="' + column + '"]').append('<i style="margin-left:10px;" class="icon-long-arrow-down"></i>')

				_log.info direction
				if Backbone.Paginator? and @collection instanceof Backbone.Paginator.requestPager
					@collection.filters.sort_column = column
					@collection.filters.sort_direction = direction
					@collection.fetch()
				else
					_log.info 'Changing comparator'
					@collection.comparator = (model1, model2) ->
						model1Val = model1.get(column)
						model2Val = model2.get(column)

						if isDate
							model1Val = moment(model1Val).unix()
							model2Val = moment(model2Val).unix()
						else if !isNaN(parseFloat(model1Val)) and !isNaN(parseFloat(model2Val))
							model1Val = parseFloat(model1Val)
							model2Val = parseFloat(model2Val)
							

						if model1Val < model2Val
							sortVal = -1
						else if model1Val > model2Val
							sortVal = 1
						else
							sortVal = 0

						if direction is 'ASC'
							return sortVal
						else
							return -1 * sortVal

				
					@collection.sort()
					@reorder()
			reorder: ->
				@collection.each (obj) =>
					obj.tableRowView.$el.prependTo(@$('tbody'))

				

			initialize: ->
				@listenTo(@collection, 'add', @addNew)
				@listenTo(@collection, 'sync', @render)
				#@listenTo(@collection, 'remove', @render)
				@subViews = []
				if !@collection.sorting?
					@collection.sorting = 
						column:null
						direction:'ASC'
			idPrefix:'obj-'
			modelView:TableRowView
			addNew: (obj) ->
				view = new @modelView
					model: obj
					tagName: 'tr'
					id:@idPrefix+ obj.get('id')
				if !view.template
					view.options.template = @options.modelTemplate

				#Strong coupling here for ordering
				obj.tableRowView = view
				index = @collection.indexOf(obj)
				before = @$('tbody tr:eq(' + index.toString() + ')')
				if before.length
					before.before view.render().el
				else
					@$('tbody').append view.render().el

			render: ->
				_log.info 'rendering!'
				@$('tbody').empty()
				@collection.each (obj) =>
					@addNew(obj)
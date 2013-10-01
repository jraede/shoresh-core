###
 * This class is for a collection that extends the Backbone.Paginator
###
define ['jquery', 'backbone'], ($, Backbone) ->
	class PaginationView extends Backbone.View
		tagName:'div'
		className:'btn-group paginated'
		events:
			'click a':'goToPage'

		initialize:->
			@listenTo @collection, 'sync', @render

		goToPage:(e) ->
			page = $(e.currentTarget).data('page')
			@collection.goTo(page)
		render: ->
			@$el.empty()
			@container = $('<ul class="pagination hidden-print"/>').appendTo(@$el)
			totalPages = @collection.info().totalPages
			_log.info @collection.info()
			currentPage = @collection.currentPage
			if totalPages < 2
				return

			#if @options.firstPageButton
			#	li = $('<li/>').appendTo(@container)
			#	firstPageButton = $('<a href="#"/>').data('page', 1).html('<i class="icon-double-angle-left"></i>').appendTo(li)
			#	if currentPage < 3
			#		firstPageButton.attr('disabled', 'disabled')

			if @options.prevPageButton
				li = $('<li/>').appendTo(@container)
				prevPageButton = $('<a href="#"/>').data('page', currentPage - 1).html("&laquo;").appendTo(li)
				if currentPage < 2
					prevPageButton.attr('disabled', 'disabled')

			pagesToShow = if @options.pagesToShow > 0 then @options.pagesToShow else 5

			# Needs to be an odd number
			if !pagesToShow %2 
				pagesToShow++

			if totalPages < pagesToShow
				min = 1
				max = totalPages

			else
				pagesOnEachSideOfCurrent = (pagesToShow - 1)/2

				min = currentPage - pagesOnEachSideOfCurrent
				max = currentPage + pagesOnEachSideOfCurrent

				# Adjust min/max based on position
				if min < 1
					diff = 1 - min
					min = 1
					max = max + diff

				else if max > totalPages
					diff = max - totalPages
					min = min - diff
					max = totalPages

			

			# Draw the page buttons
			for i in [min..max] by 1
				li = $('<li/>').appendTo(@container)
				if i is currentPage
					li.addClass('active')
				$('<a href="#"/>').data('page', i).html(i.toString()).appendTo(li)




			if @options.nextPageButton
				li = $('<li/>').appendTo(@container)
				nextPageButton = $('<a href="#"/>').data('page', currentPage + 1).html("&raquo;").appendTo(li)
				if currentPage >= totalPages
					nextPageButton.attr('disabled', 'disabled')
			#if @options.lastPageButton
			#	li = $('<li/>').appendTo(@container)
			#	lastPageButton = $('<a href="#"/>').data('page', totalPages).html('<i class="icon-double-angle-right"></i>').appendTo(li)
			#	if currentPage >= (totalPages - 1)
			#		lastPageButton.attr('disabled', 'disabled')

			# Add the visible print thing
			$('<h2 class="visible-print"/>').html('Page ' + currentPage.toString()).appendTo(@$el)
			@delegateEvents()




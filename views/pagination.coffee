###
 * This class is for a collection that extends the Backbone.Paginator
###
define ['jquery', 'backbone'], ($, Backbone) ->
	class PaginationView extends Backbone.View
		tagName:'div'
		className:'btn-group paginated'
		events:
			'click button':'goToPage'

		initialize:->
			@listenTo @collection, 'sync', @render

		goToPage:(e) ->
			page = $(e.currentTarget).data('page')
			@collection.goTo(page)
		render: ->
			@$el.empty()
			totalPages = @collection.info().totalPages
			currentPage = @collection.currentPage
			if totalPages < 2
				return

			if @options.firstPageButton
				firstPageButton = $('<button class="btn btn-default page-nav"/>').data('page', 1).html('<i class="icon-double-angle-left"></i>').appendTo(@$el)
				if currentPage < 3
					firstPageButton.attr('disabled', 'disabled')

			if @options.prevPageButton
				prevPageButton = $('<button class="btn btn-default page-nav"/>').data('page', currentPage - 1).html('<i class="icon-angle-left"></i>').appendTo(@$el)
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
				if i is currentPage
					$('<button class="btn btn-primary current-page"/>').data('page', i).attr('disabled', 'disabled').html(i.toString()).appendTo(@$el)
				else
					$('<button class="btn btn-default"/>').data('page', i).html(i.toString()).appendTo(@$el)




			if @options.nextPageButton
				nextPageButton = $('<button class="btn btn-default page-nav"/>').data('page', currentPage + 1).html('<i class="icon-angle-right"></i>').appendTo(@$el)
				if currentPage >= totalPages
					nextPageButton.attr('disabled', 'disabled')
			if @options.lastPageButton
				lastPageButton = $('<button class="btn btn-default page-nav"/>').data('page', totalPages).html('<i class="icon-double-angle-right"></i>').appendTo(@$el)
				if currentPage >= (totalPages - 1)
					lastPageButton.attr('disabled', 'disabled')
			@delegateEvents()




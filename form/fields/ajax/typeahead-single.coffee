###
 * This class creates a bootstrap typeahead element
 * with an AJAX data source for either a has_many or 
 * many_many relationship with the main model.
 *
 * The main model's API should return an array of objects 
 * with properties "id" and "label" so that this field can 
 * be pre-populated, and the data source for this field should 
 * return the same format.
 *
 * E.g,
 *
 * [
 * 	{id:1, label:'Object 1'},
 * 	{id:2, label:'Object 2'}
 * ]
 *
 * The pre-existing and chosen values are shown in a UL with
 * a remove button.
 *
 * The actual API can handle this field either as a has_many 
 * or many_many relationship, it it exactly the same from a 
 * front-end standpoint
 *
 * You optionally can specify a "display" property in the field 
 * config as a function that takes the LI element and the object 
 * label and performs any additional UI process on it.
 * 
 *
 * @package  Shoresh
 * @subpackage  Form
 * @author  Jason Raede <j@jasonraede.com>
 * 
 * -------------
 * Requirements:
 * -------------
 *
 * Twitter Bootstrap Typeahead
 * @url  http://twitter.github.io/bootstrap/javascript.html
 *
 * Twitter Bootstrap CSS
 * @url  http://twitter.github.io/bootstrap/index.html
 *
 * Font Awesome (for default "remove" button icon)
 * @url  http://fortawesome.github.io/Font-Awesome/
###

define ['core/form/field', 'jquery', 'core/ui/bootstrap/typeahead'], (Field, $) ->
	class TypeaheadAjaxSingle extends Field
		constructor: ->
			super
			@value = null
		render:->
			label = $('<label/>').html(@options.label).appendTo @$el
			input = $('<input type="text"/>').appendTo @$el
			if @options.help
				$('<p class="help-block"/>').html(@options.help).insertBefore input
			@postRender()

			return @$el


		postRender: ->
			@searchField = @$('input[type="text"]')
			@searchField.attr('autocomplete', 'off')
			# Set up the typeahead
			@searchField.typeahead
				# Having the source with ID + label is a little
				# hackish, so we do it with @@@@, assuming
				# no label or id will have @@@@
				source: (query, process) =>
					console.log 'typing...'
					if @options.onStartTyping and typeof @options.onStartTyping is 'function'
						@options.onStartTyping
					$.getJSON @options.dataSourceUrl,{q:query}, (response) =>
						results = []
						if response.length
							for result in response
								# Make sure the id is not already chosen
								results.push(result.id + '@@@@' + result.label)

						process(results)
				# Here we basically shift off the "id" portion
				# and are left with the label for display
				highlighter: (item) ->
					parts = item.split('@@@@')
					parts.shift()
					return parts.join('@@@@')
				updater: (item) =>
					parts = item.split('@@@@')
					id = parts.shift()
					label = parts.shift()

					# This is run when they click, so add the value
					@value = {id:id, label:label}

					if @options.onSelect and typeof @options.onSelect is 'function'
						@options.onSelect(@value)
					return label

			
			super
		getValue: ->		
			return @value

		

		populateSelf: ->
			property = @options.property
			if @model
				val = @model.get(property)
				if typeof val is 'object'
					@value = val
					@searchField.val(val.label)



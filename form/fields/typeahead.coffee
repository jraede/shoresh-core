###
 * Requirements:
 *
 *
 * Twitter Bootstrap CSS
 * @url  http://twitter.github.io/bootstrap/index.html
###
define ['core/ui/bootstrap/bootstrap', 'core/form/fields/text'], (Text) ->
	class BootstrapTypeahead extends Text
		postRender:->
			super
			@$('input').typeahead
				source: @options.options
			

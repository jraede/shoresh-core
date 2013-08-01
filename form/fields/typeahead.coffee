###
 * Requirements:
 *
 *
 * Twitter Bootstrap CSS
 * @url  http://twitter.github.io/bootstrap/index.html
###
define ['components/ui/bootstrap/bootstrap', 'components/form/fields/text'], (Text) ->
	class BootstrapTypeahead extends Text
		postRender:->
			super
			@$('input').typeahead
				source: @options.options
			

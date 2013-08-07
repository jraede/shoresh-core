define ['jquery', 'core/number/format'], ($, NumberFormat) ->
	$.priceMask =
		format:(val) ->
			val = val.replace(/[^0-9\$\.]/g, '')
			# Rule 1: must start with $
			if !val or val.length is 0
				return '$'

			if val.substr(0, 1) isnt '$'
				val = '$' + val

			# Make sure there's only one period. If there's a second one, cut it off at the second
			periodCount = val.match(/\./g)

			if periodCount and periodCount.length > 1
				split = val.split('.')
				for i in [0..(periodCount - 1)] by 1
					split.pop()

				val = split.join('.')

			# Now make sure there are only two digits after the period
			index = val.indexOf('.')
			if index >= 0
				if val.length - (index + 1) > 2
					val = val.substr(0, index + 3)

			

			return val
		makePretty: (val) ->
			return '$' + NumberFormat(val, 2)
			




	$.fn.priceMask = (options) ->
		return @each ->

			if $(@).val()
				$(@).val($.priceMask.makePretty($.priceMask.format($(@).val())))
			$(@).keydown (e) ->
				key = e.charCode or e.keyCode or 0

				# Allow $ . and numbers. and backspace. and arrows
				allowed = [8,9,37,38,39,40, 48,49,50,51,52,53,54,55,56,57,190,96,97,98,99,100,101,102,103,104,105]

				if !e.shiftKey and allowed.indexOf(key) >= 0
					return true

				# Check for $
				else if e.shiftKey and key is 52
					return true

				return false
			$(@).blur (e) ->
				$(@).val($.priceMask.makePretty($(@).val()))
			$(@).keyup (e) ->
				key = e.charCode or e.keyCode or 0
				if key > 40 or key < 37 and key isnt 8
					val = $(@).val()

					regex = /^\$\d+?\.?(\d\d)?$/

					match = val.toString().match(regex);
					if match isnt null and val is match[0]

						return true

					$(@).val($.priceMask.format($(@).val()))

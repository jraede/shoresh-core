define [], ->
	class NumberHelper
		@round: (number, decimals = 0) ->
			multiplier = Math.pow(10, decimals);


			number = Math.floor(parseFloat(number) * multiplier) / multiplier

			return number
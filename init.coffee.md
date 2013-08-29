core/init
===

**Package**: Shoresh

**Subpackage**: Core

**Author**: Jason Raede <jason.raede@gmail.com>

This file initializes the framework by loading global utilities and looking for the page controller.

---

Load the utilities since they are used across the board for every page load.

	require ['core/utilities'], ->

Set the boot time on the logger so it can report accurately

		_log.bootTime = new Date().getTime()


		
Now we look for the page controller and try to load it.

	path = window.location.pathname

If there's no file extension, we assume it's a folder. Otherwise strip the extension and use that

	explode = path.split('/')
	count = explode.length
	if !explode[count - 1].length
		explode.splice(count - 1, 1)


	if !explode[0].length
		explode.splice(0, 1)
	pathToCheck = explode[explode.length - 1]

If your Shoresh configuration allows file extensions, we assume that paths without an extension resolve to `index`. Otherwise if you're using some sort of mod-rewrite rule and are not using file extensions, set `fileExtensions` to `false` and it will just look for the file with `.js` appended to the current path.

	if window.shoreshConfig and window.shoreshConfig.fileExtensions is true
		if pathToCheck.indexOf('.') >= 0
			
			explode[explode.length - 1] = pathToCheck.substr(0, pathToCheck.lastIndexOf('.'))
		else
			explode.push('index')

	else if !explode.length
		explode.push('index')
	requirejs.onError = (err) ->
		if err.requireModules[0].indexOf('app/controllers/') isnt 0
			throw err

	    
	require ['app/controllers/' + explode.join('/')]


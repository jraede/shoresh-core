

# Look for the page controller and try to load it


path = window.location.pathname

# If there's no file extension, we assume it's a folder. Otherwise strip the extension and use that

explode = path.split('/')
count = explode.length
if !explode[count - 1].length
	explode.splice(count - 1, 1)


if !explode[0].length
	explode.splice(0, 1)
pathToCheck = explode[explode.length - 1]


if window.shoreshConfig and window.shoreshConfig.fileExtensions is true
	if pathToCheck.indexOf('.') >= 0
		# strip out the extension
		explode[explode.length - 1] = pathToCheck.substr(0, pathToCheck.lastIndexOf('.'))
	else
		explode.push('index')


requirejs.onError = (err) ->
	if err.requireModules[0].indexOf('app/controllers/') isnt 0
		throw err

    
require ['app/controllers/' + explode.join('/')]


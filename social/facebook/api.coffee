define ['components/social/facebook/connect'], (FB) ->
	class FacebookAPI
		@accessToken:null
		@login: (scope, callback) ->
			if !scope then scope = ''

			FB.login (response) =>
				if response.authResponse and response.authResponse.accessToken
					@accessToken = response.authResponse.accessToken
				
				if callback then callback(response)
			,
				scope:scope
		
		@logout: (callback) ->
			FB.logout ->
				if callback then callback()

		@request: (call, callback) ->
			url = call
			if @accessToken
				if url.indexOf('?') > -1 then url = url + 'accessToken=' + @accessToken
				else url = url + '?accessToken=' + @accessToken

			FB.api url, (response) ->
				if callback then callback(response)
		@initialize: (appId, channelUrl, callback) ->
			FB.init
				appId      : appId
				channelUrl : channelUrl
				status     : true
				cookie     : true
				oauth      : true
				xfbml      : true
				frictionlessRequests : false
			FB.getLoginStatus (response) ->
				if response.authResponse and response.authResponse.accessToken
					@accessToken = response.authResponse.accessToken
				if callback then callback(response)

		@getUserInfo: (id, fields, callback) ->
			if fields then fields = '?fields=' + fields
			else fields = ''
			@request('/' + id + fields, callback)
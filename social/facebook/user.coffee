define ['components/social/facebook/api'], (FBApi) ->
	class FacebookUser 
		id:null
		userInfo:{}
		friends:[]
		inMiddleOfRetrievingData:false
		infoCallbacks:[]
		constructor:(id) ->
			@id = id
		getInfo: (field, callback) ->
			if @userInfo.id and @userInfo[field]
				callback(@userInfo[field])
			else if @inMiddleOfRetrievingData
				@infoCallbacks.push
					field:field
					callback:callback
			else
				@inMiddleOfRetrievingData = true
				FBApi.getUserInfo 'me', false, (response) =>
					@inMiddleOfRetrievingData = false
					@userInfo = response
					callback(@userInfo[field])
					@executeInfoCallbacks()
		###
		 * Returns the URL of a user's profile picture
		 *
		 * @param string size ->
		 *		'square' :: 50x50
		 *		'small'  :: 50x?
		 *		'normal' :: 100x?
		 *		'large'  :: 200x?
		###
		profilePicture: (size) ->
			if size then size = '?type=' + size
			else size = ''

			return 'http://graph.facebook.com/' + @id + '/picture' + size

		executeInfoCallbacks: ->
			for callback in @infoCallbacks
				@getInfo callback.field, callback.callback

			@infoCallbacks = []

		getFriends: (callback) ->
			if @friends.length then callback(@friends)
			else
				FBApi.request '/me/friends', (response) =>
					@friends = response.data
					callback(@friends)
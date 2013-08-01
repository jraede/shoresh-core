###
 * Facebook Connect
 *
 * Handles connecting to Facebook and displaying data.
 *
 * All requests from any of those objects to another 
 * object run through this object.
 *
 * @package Shoresh
 * @subpackage  Social
 * @author Jason Raede 
 ###

define ['core/social/facebook/api', 'core/social/facebook/user', 'core/social/facebook/connect'], (FBApi, FBUser, FB) ->
	class FacebookConnect
		@events:
			userLoggedIn:[]
			userNotLoggedIn:[]
			loginSuccessful:[]
			loginFailed:[]
			loggedOut:[]
		@bindEvent: (event, callback) ->
			@events[event].push callback

		@unbind: (event) ->
			@events[event] = []

		@triggerEvent: (event, args) ->
			__.log 'triggering facebook event: ' + event
			if @events[event]
				for callback in @events[event]
					callback(args)

		@currentUser:null
		@fetchedUser: false
		@retrievingUserData:false
		@initialized: false
		@initCallbacks:[]
		@executeInitCallbacks: ->
			__.log 'executing init callbacks'
			for callback in @initCallbacks
				@loggedIn(callback)
			@initCallbacks = []
		@userInfoCallbacks:[]
		@executeUserInfoCallbacks: ->
			for callback in @userInfoCallbacks
				@getUserInfo callback.field, callback.callback

		@initialize: (appId, channelUrl) ->
			FBApi.initialize appId, channelUrl, (response) =>
				if response.authResponse and response.authResponse.accessToken
					@didLogin(response)

					@triggerEvent 'userLoggedIn'
				else
					@initialized = true
					@executeInitCallbacks()
					@triggerEvent 'userNotLoggedIn'

		@loggedIn: (callback) ->
			if !@initialized
				@initCallbacks.push(callback)
			else
				callback(if @currentUser then @currentUser.id else false)

		@didLogin: (response) ->
			@initialized = true
			@currentUser = new FBUser(response.authResponse.userID)
			@executeInitCallbacks()


		@postToWall: (story, complete) ->
			story.method = 'feed'
			FB.ui story, complete
			
		@login: (scope, success, error) ->
			FBApi.login scope, (response) =>
				if response.authResponse and response.authResponse.accessToken
					@didLogin(response)
					@triggerEvent 'loginSuccessful'
					if success then success(response)
				else 
					@triggerEvent 'loginFailed'
					if error then error(response)
		
		@logout: (callback) ->
			FBApi.logout =>
				if callback then callback()
				@currentUser = null
				@triggerEvent 'loggedOut'

		@getUserInfo: (field, callback) ->
			if @fetchedUser and @currentUser[field]
				callback @currentUser[field]

			else if @retrievingUserData
				@userInfoCallbacks.push
					field:field
					callback:callback
			else
				@retrievingUserData = true
				@apiCall '/' + @currentUser.id, =>
					@currentUser = response
					@retrievingUserData = false
					@fetchedUser = true
					@executeUserInfoCallbacks()
					callback(@currentUser[field])
			
	
	
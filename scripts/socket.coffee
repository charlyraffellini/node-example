app.factory 'socket', ($rootScope) ->
  socket = io.connect()
  on: (eventName, callback) ->
    wrapper = ->
      args = arguments
      $rootScope.$apply ->
        callback.apply socket, args
    socket.on eventName, wrapper
    -> socket.removeListener eventName, wrapper
  emit: (eventName, data, callback) ->
    socket.emit eventName, data, ->
      args = arguments
      $rootScope.$apply ->
        callback.apply(socket, args) if callback

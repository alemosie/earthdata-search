
ns = @edsc.models.data

ns.Preferences = do (ko
                     getJSON = jQuery.getJSON
                     doPost = jQuery.post
                     ) ->

  class Preferences
    constructor: (@user) ->
      # Default Preferences
      @showTour = ko.observable(true)
      @dismissedEvents = ko.observableArray([])
      @isLoaded = ko.observable(false)

      @load()

    load: ->
      getJSON '/users/site_preferences', (data, status, xhr) =>
        console.log "Loaded site preferences, #{JSON.stringify(data)}"

        @fromJson(data)
        @isLoaded(true)
      null

    onload: (fn) ->
      ko.computed
        read: =>
          @isLoaded()
        disposeWhen: =>
          isLoaded = @isLoaded()
          fn(this) if isLoaded
          isLoaded
      null


    save: ->
      serialized = @serialize()
      console.log "Saving site preferences, #{JSON.stringify(serialized)}"
      doPost '/users/site_preferences', {site_preferences: serialized}
      null

    fromJson: (jsonObj) =>
      return unless jsonObj?
      @showTour(jsonObj.show_tour != 'false')
      @dismissedEvents(jsonObj.dismissed_events ? [])

    serialize: =>
      json =
        show_tour: @showTour()
        dismissed_events: @dismissedEvents()

  exports = Preferences

YoutrackGame.BaseController = Ember.ArrayController.extend
  getForTrackedMembers: (->
    ids = YoutrackGame.config.get('trackedMembersIds')
    if ids
      @filter (object) -> ids.indexOf(object.member_id) isnt -1
    else
      []
  ).property("content", "YoutrackGame.config.trackedMembersIds")
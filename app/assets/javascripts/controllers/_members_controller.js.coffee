YoutrackGame.MembersController = Ember.ArrayController.create({
  currentMember: (->
    @findProperty("id", YoutrackGame.config.get('currentMemberId'));
  ).property('content','YoutrackGame.config.currentMemberId')
})
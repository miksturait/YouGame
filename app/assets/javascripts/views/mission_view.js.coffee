YoutrackGame.MissionView = Ember.View.extend
  allMembersBinding: 'YoutrackGame.MembersController.content'
  currentMemberBinding: 'YoutrackGame.MembersController.currentMember'
  templateName: "mission"
  logsBinding: "YoutrackGame.ActivitiesController.getForTrackedMembers"
  levelBinding: "YoutrackGame.LevelController"

  latestLogs: (->
    @get('logs').slice(0,3)
  ).property('logs')

  hasLatestLogs: (->
    @get('latestLogs').length > 0
  ).property('latestLogs')

  showMemberProfile: (e) ->
    YoutrackGame.MembersController.set('selectedMember', e.context)
    YoutrackGame.changePage('profile')
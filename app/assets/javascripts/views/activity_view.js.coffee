YoutrackGame.ActivityView = Ember.View.extend
  templateName: "activity"
  activitiesBinding: "YoutrackGame.ActivitiesController.getForTrackedMembers"

  showMemberProfile: (e) ->
    YoutrackGame.MembersController.set('selectedMember', e.context)
    YoutrackGame.changePage('profile')
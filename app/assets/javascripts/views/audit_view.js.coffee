YoutrackGame.AuditView = Ember.View.extend
  auditsBinding: 'YoutrackGame.AuditsController.content'
  templateName: "audit"

  showMemberProfile: (e) ->
    YoutrackGame.MembersController.set('selectedMember', e.context)
    YoutrackGame.changePage('profile')
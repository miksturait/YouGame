YoutrackGame.RankingEntryView = Ember.View.extend
  templateName: "ranking_entry"
  classNames: ['ranking_entry', 'well']

  showMemberProfile: (e) ->
    YoutrackGame.MembersController.set('selectedMember', e.context)
    YoutrackGame.changePage('profile')
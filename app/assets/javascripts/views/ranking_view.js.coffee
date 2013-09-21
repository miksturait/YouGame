YoutrackGame.RankingView = Ember.View.extend
  templateName: "ranking"
  rankingTypeBinding: 'YoutrackGame.RankingController.rankingType'
  rankingEntriesBinding: 'YoutrackGame.RankingController.relativeRankingEntries'
  allEntriesBinding: 'YoutrackGame.RankingController.getForTrackedMembers'
  otherMembersBinding: 'YoutrackGame.RankingController.otherMembers'

  rankingNames:
    today: "Experience Gained Today"
    week: "Experience Gained This Week"
    month: "Experience Gained This Month"

  nameOfRanking: (->
    @get('rankingNames')[@get('rankingType')]
  ).property("rankingType")

  hasMoreInTop: (->
    @get('rankingEntries')[0].get('placeInRanking') != 1
  ).property('rankingEntries')

  hasMoreInBottom: (->
    lastIndex = @get('rankingEntries').length - 1
    @get('rankingEntries')[lastIndex].get('placeInRanking') != @get('allEntries').length
  ).property('rankingEntries')

  showMemberProfile: (e) ->
    YoutrackGame.MembersController.set('selectedMember', e.context)
    YoutrackGame.changePage('profile')
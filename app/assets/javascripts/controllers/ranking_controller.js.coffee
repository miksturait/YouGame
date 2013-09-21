YoutrackGame.RankingController = YoutrackGame.BaseController.create
  rankingType: 'today'

  getForTrackedMembers: (->
    ids = YoutrackGame.config.get('trackedMembersIds')
    if ids
      @filter (object) -> ids.indexOf(object.member_id) isnt -1
    else
      []
  ).property("content.@each.today", "content.@each.week", "content.@each.month", "YoutrackGame.config.trackedMembersIds")

  currentMemberEntry:(->
    currentMember = YoutrackGame.MembersController.get('currentMember')
    @get('getForTrackedMembers').findProperty('member_id', currentMember.get('id'))
  ).property('getForTrackedMembers', 'currentMember')

  sortedRankingEntries: (->
    @get('getForTrackedMembers').sort (a, b) ->
      if a.get('getPoints') > b.get('getPoints')
        -1
      else if a.get('getPoints') < b.get('getPoints')
        1
      else
        0
  ).property('getForTrackedMembers.@each.getPoints', 'rankingType')

  relativeRankingEntries: (->
    myEntryPlace = @get('currentMemberEntry').get('placeInRanking')
    start = if myEntryPlace == 1
      0
    else if myEntryPlace == @get('getForTrackedMembers').length
      myEntryPlace-3
    else
      myEntryPlace-2
    @get('sortedRankingEntries').slice(start, start + 3)
  ).property('sortedRankingEntries', 'currentMemberEntry')

  otherMembers: (->
    copy = @get('getForTrackedMembers').toArray()
    copy.removeObjects(@get('relativeRankingEntries')).mapProperty('member').shuffle()
  ).property('sortedRankingEntries', 'currentMemberEntry')

  getMaximumPoints: (->
    if @get('content')
      Math.max.apply(Math, @get('content').mapProperty(@get('rankingType'))) * 110.0 / 100.0
    else
      0
  ).property("content", "rankingType")
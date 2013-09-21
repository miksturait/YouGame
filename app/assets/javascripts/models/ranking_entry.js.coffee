YoutrackGame.RankingEntry = YoutrackGame.MemberObject.extend

  getMaximumPointsBinding: 'YoutrackGame.RankingController.getMaximumPoints'
  rankingTypeBinding: 'YoutrackGame.RankingController.rankingType'

  getPoints: (->
    @get(@get('rankingType'))
  ).property("rankingType")

  getFormattedPoints: (->
    formattedNumber(@get('getPoints'))
  ).property("getPoints")

  getProgressBarStyle: (->
    percent = @get('getPoints') / @get('getMaximumPoints') * 100.0
    'width: ' + percent + '%'
  ).property("getPoints")

  placeInRanking:(->
    YoutrackGame.RankingController.get('sortedRankingEntries').indexOf(@) + 1
  ).property("getPoints")
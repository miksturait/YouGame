YoutrackGame.AchievementObtain = YoutrackGame.MemberObject.extend
  allAchievementsBinding: "YoutrackGame.AchievementsController.content"

  getAchievement: (->
    @get('allAchievements').findProperty('id', @get('achievement_id'))
  ).property('achievement_id')

  getName: (->
    @get('getAchievement').get('name')
  ).property('getAchievement')

  getExpPoints: (->
    @get('getAchievement').get('exp_points')
  ).property('getAchievement')

  getMineralPoints: (->
    @get('getAchievement').get('mineral_points')
  ).property('getAchievement')

  getMessage: (->
    @get('getAchievement').get('message')
  ).property('getAchievement')

  getPictureUrl: (->
    @get('getAchievement').get('original_picture')
  ).property('getAchievement')
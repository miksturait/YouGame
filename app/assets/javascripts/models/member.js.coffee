YoutrackGame.Member = Ember.Object.extend
  allLogsBinding: "YoutrackGame.ActivitiesController.getForTrackedMembers"
  allTasksBinding: "YoutrackGame.AssignmentsController.getForTrackedMembers"
  allAchievementsObtainsBinding: "YoutrackGame.AchievementsObtainsController"
  currentLevelBinding: "YoutrackGame.LevelController.content"

  avatarMidUrl: (->
    @get("avatar_url") + "?s=100"
  ).property("avatar_url")

  avatarSemiMidUrl: (->
    @get("avatar_url") + "?s=80"
  ).property("avatar_url")

  avatarSmallUrl: (->
    @get("avatar_url") + "?s=24"
  ).property("avatar_url")

  fiveLatestLogs: (->
    @get('allLogs').filterProperty('member_id', @get('id')).slice(0,5)
  ).property('allLogs')

  hasLogs: (-> @get('fiveLatestLogs').length > 0).property('fiveLatestLogs')

  backlogTasks: (->
    @get('allTasks').findProperty('member_id', @get('id')).get('backlog')
  ).property('allTasks')

  hasBacklogTasks: (-> @get('backlogTasks').length > 0).property('backlogTasks')

  inProgressTasks: (->
    @get('allTasks').findProperty('member_id', @get('id')).get('in_progress')
  ).property('allTasks')

  hasInProgressTasks: (-> @get('inProgressTasks').length > 0).property('inProgressTasks')

  acceptedTasks: (->
    @get('allTasks').findProperty('member_id', @get('id')).get('accepted')
  ).property('allTasks')

  hasAcceptedTasks: (-> @get('acceptedTasks').length > 0).property('acceptedTasks')

  achievementsObtains: (->
    @get('allAchievementsObtains').filterProperty('member_id', @get('id'))
  ).property('allAchievementsObtains')

  groupedAchievementsObtains: (->
    (@get('achievementsObtains') || []).partition(4)
  ).property('achievementsObtains')

  hasAchievementsObtains: (-> @get('achievementsObtains').length > 0).property('achievementsObtains')

  expLevelRange: (->
    scope = @
    $.grep(YoutrackGame.Game.expLevels, (range)-> scope.get('exp_points') >= range[0] and scope.get('exp_points') < range[1])[0]
  ).property('exp_points')

  expLevelIndex: (->
    YoutrackGame.Game.expLevels.indexOf(@get('expLevelRange'))
  ).property('expLevelRange')

  expLevel: (->
    @get('expLevelIndex') + 1
  ).property('expLevelIndex')

  expLevelMinPoints: (->
    @get('expLevelRange')[0]
  ).property('expLevelRange')

  expLevelMaxPoints: (->
    @get('expLevelRange')[1]
  ).property('expLevelRange')

  expLevelName: (->
    YoutrackGame.Game.expLevelNames[@get('expLevelIndex')]
  ).property('expLevelIndex')

  hasCurrentLevelMinerals: (->
    parseInt(@get('current_level_minerals')) > 0
  ).property('current_level_minerals')

  formattedCurrentLevelMinerals: (->
    formattedNumber(@get('current_level_minerals'))
  ).property('current_level_minerals')

  currentLevelMineralLabel: (->
    formattedNumber(@get('formattedCurrentLevelMinerals')) + " " + @get('currentLevel').get('mineral_label') + " collected by me"
  ).property('formattedCurrentLevelMinerals', 'currentLevel.mineral_label')

  shareInLevelMinerals: (->
    if @get('hasCurrentLevelMinerals') and @get('currentLevel')
      parseInt(@get('current_level_minerals')) / parseInt(@get('currentLevel').get('target')) * 100
    else
      0
  ).property('current_level_minerals', 'currentLevel.target')

  mineralsProgressBarEnd: (->
    greatest = @get('total_minerals_points')[0] || [null, 0]
    greatest[1] * 120.0 / 100.0
  ).property('total_minerals_points')

  mineralsList: (->
    scope = @
    result = []
    $.each @get('total_minerals_points'), (index, data)->
      mineral_name = data[0]
      points = data[1]
      mineral = YoutrackGame.MineralsController.get('content').findProperty('mineral_name', mineral_name)
      mineral.set('total_minerals_points', formattedNumber(points))
      mineral.set('mineral_progress_style', 'width:'+(points / scope.get('mineralsProgressBarEnd') * 100.0)+'%')
      result.push(mineral)
    result
  ).property('total_minerals_points', 'YoutrackGame.MembersController.selectedMember')

  collectedAnyMineral: (->
    @get('mineralsList').length > 0
  ).property('mineralsList')

  currentStamina: (->
    recovery_at = Date.parse(@get('stamina_recovered_at')) || YoutrackGame.config.get('currentTime').getTime()
    stamina = 100 - (100 * (recovery_at - YoutrackGame.config.get('currentTime').getTime()) / 3600000  / 8)
    stamina = Math.max(0, Math.min(100, Math.round(stamina)))

    # update stamina knob in profile
    currentMember = YoutrackGame.MembersController.get('currentMember')
    member        = YoutrackGame.MembersController.get('selectedMember') || currentMember
    $('.dossier-stamina input').val(stamina).trigger('change') if @get('id') == member.get('id')

    stamina
  ).property('stamina_recovered_at', 'YoutrackGame.config.currentTime')

  cssStamina: (->
    classes = ['knob-input']
    if @get('currentStamina') < 30
      'knob-input dossier-stamina-critical'
    else if @get('currentStamina') < 50
      'knob-input dossier-stamina-warning'
    else
      'knob-input'
  ).property('currentStamina')
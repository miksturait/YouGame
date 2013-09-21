YoutrackGame.DataController = YoutrackGame.ApplicationController.create

  loadData: (data) ->
    @_loadMembers data.members                          if data.members
    @_loadMinerals data.minerals                        if data.minerals
    @_loadAssignments data.current_assignments          if data.current_assignments
    @_loadRankingEntries data.ranking                   if data.ranking
    @_loadActivities data.activities                    if data.activities
    @_loadAudits data.audits                            if data.audits
    @_loadAchievements data.achievements                if data.achievements
    @_loadAchievementsObtains data.achievements_obtains if data.achievements_obtains
    @_loadLevel data.level                              if data.level
    @_showAudits()                                      if data.audits
    @_updateKnobs()

  _loadMembers: (data) ->
    result = []
    $(data).each (index, params) ->
      result.push YoutrackGame.Member.create(params)
    YoutrackGame.MembersController.set "content", result

  _loadMinerals: (data) ->
    result = []
    $(data).each (index, params) ->
      result.push YoutrackGame.Mineral.create(params)
    YoutrackGame.MineralsController.set "content", result

  _loadAssignments: (data) ->
    result = []
    $(data).each (index, params) ->
      result.push YoutrackGame.Assignment.create(params)
    YoutrackGame.AssignmentsController.set "content", result

  _loadRankingEntries: (data) ->
    result = []
    $(data).each (index, params) ->
      result.push YoutrackGame.RankingEntry.create(params)
    YoutrackGame.RankingController.set "content", result

  _loadActivities: (data) ->
    result = []
    $(data).each (index, params) ->
      result.push YoutrackGame.Activity.create(params)
    YoutrackGame.ActivitiesController.set "content", result

  _loadAudits: (data) ->
    result = []
    $(data).each (index, params) ->
      result.push YoutrackGame.Activity.create(params)
    YoutrackGame.AuditsController.set "content", result

  _loadAchievements: (data) ->
    result = []
    $(data).each (index, params) ->
      result.push YoutrackGame.Achievement.create(params)
    YoutrackGame.AchievementsController.set "content", result

  _loadAchievementsObtains: (data) ->
    result = []
    $(data).each (index, params) ->
      result.push YoutrackGame.AchievementObtain.create(params)
    YoutrackGame.AchievementsObtainsController.set "content", result

  _loadLevel: (data) ->
    YoutrackGame.LevelController.set "content", YoutrackGame.Level.create(data)

  _updateKnobs: ->
    level = YoutrackGame.LevelController.get('content')
    currentMember = YoutrackGame.MembersController.get('currentMember')
    member = YoutrackGame.MembersController.get('selectedMember') || currentMember
    $('#mission-mineral-progress').val(level.get('progress')).trigger('change');
    $('.dossier-progress input').val(member.get('exp_points')).trigger('change');
    $('.dossier-stamina input').val(member.get('currentStamina')).trigger('change');
    $('#mission-mineral-member').val(currentMember.get('shareInLevelMinerals')).trigger('change');

  _showAudits: ->
    # Audits page
    if YoutrackGame.AuditsController.get('content').length > 0
      currentPage = YoutrackGame.currentPage
      YoutrackGame.changePage('audit')
      YoutrackGame.returnFromAuditsTimeout = setTimeout( ->
        YoutrackGame.changePage(currentPage)
      , 10000)

    # Notifications for current member
    auditsToNotify = YoutrackGame.AuditsController.get('auditsToNotify')
    if auditsToNotify.length > 0 and webkitNotifications? and webkitNotifications.checkPermission() == 0
      YoutrackGame.sounds.notify.play()
      $.each auditsToNotify, (index, audit)->
        notification = webkitNotifications.createNotification('',audit.get('subject'), $(audit.get('text')).text())
        notification.show()
        setTimeout((-> notification.close()), 10000)
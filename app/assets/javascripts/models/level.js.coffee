YoutrackGame.Level = Ember.Object.extend
  progress: (->
    Math.min(Math.floor(@get('collected') / @get('target') * 100), 100)
  ).property('collected', 'target')

  timeProgress: (->
    Math.min(Math.floor((new Date()).getDate() / moment().endOf('month')._d.getDate() * 100), 100)
  ).property('collected', 'target')

  cssMissionTime: (->
    diff  = @get('progress') - @get('timeProgress')
    klass = if diff > -5
      'time-ok'
    else if diff > -15
      'time-warning'
    else
      'time-alert'
    "mission-time " + klass
  ).property('progress', 'timeProgress')

  titleMissionTime: (->
    diff = @get('progress') - @get('timeProgress')
    if diff > -5
      'We are on right track!'
    else if diff > -15
      'We are behind the schedule, let\'s speed up!'
    else
      'Mission is in danger, but it\'s not too late!'
  ).property('progress', 'timeProgress')

  isMissionCompleted: (->
    @get('progress') == 100
  ).property('progress')

  producedMineralLabel: (->
    formattedNumber(@get('collected')) + " " + @get('mineral_label') + " collected by team"
  ).property('collected')

  requiredMineralLabel: (->
    formattedNumber(@get('target')) + " " + @get('mineral_label') + " required"
  ).property('target')

  broodPreview: (->
    $('<img>', src: @get('brood_image_path'))[0].outerHTML
  ).property('brood_image_path')

  planetPreview: (->
    $('<img>', src: @get('planet_image_path'))[0].outerHTML
  ).property('planet_image_path')

  mineralPreview: (->
    $('<img>', src: @get('mineral_image_path'))[0].outerHTML
  ).property('mineral_image_path')
Ember.Handlebars.registerHelper "value_or_none", (path) ->
  escaped = Handlebars.Utils.escapeExpression(this[path])
  escaped or "none"

Ember.Handlebars.registerHelper "raw", (path) ->
  new Ember.Handlebars.SafeString(this[path])

Ember.Handlebars.registerHelper "difficultyLevel", (path) ->
  if !this[path] then 'No effort' else this[path]

Ember.Handlebars.registerHelper "linkForIssue", (path) ->
  YoutrackGame.LevelController.get('content').get('tracker_url') + '/issue/' + this[path]

Ember.Handlebars.registerHelper "difficultyLevelClass", (path) ->
  switch this[path]
    when 'Easy' then 'label-success'
    when 'Medium' then 'label-warning'
    when 'Hard' then 'label-important'
    else 'label-default'

YoutrackGame.AuditsController = YoutrackGame.BaseController.create

  auditsToNotify: (->
    @filterProperty('notify', true)
  ).property('content')
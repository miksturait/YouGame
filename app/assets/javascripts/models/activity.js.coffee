YoutrackGame.Activity = YoutrackGame.MemberObject.extend

  formattedCreatedAt: (->
    moment(@get('created_at')).format('YYYY-MM-DD, HH:mm')
  ).property('created_at')

  formattedTimeAgo: (->
    moment(@get('created_at')).from(YoutrackGame.config.get('currentTime'))
  ).property('created_at', 'YoutrackGame.config.currentTime')
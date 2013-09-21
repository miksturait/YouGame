YoutrackGame.Assignment = YoutrackGame.MemberObject.extend
  hasInProgress: (->
    @get("in_progress").length > 0
  ).property("in_progress")
  hasBacklog: (->
    @get("backlog").length > 0
  ).property("backlog")
  hasAccepted: (->
    @get("accepted").length > 0
  ).property("accepted")
  hasNoData: (->
    not @get("hasInProgress") and not @get("hasBacklog") and not @get("hasAccepted")
  ).property("hasInProgress", "hasBacklog", "hasAccepted")
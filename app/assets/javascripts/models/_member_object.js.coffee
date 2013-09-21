YoutrackGame.MemberObject = Ember.Object.extend(
  member: (->
    YoutrackGame.MembersController.findProperty "id", @get("member_id")
  ).property("member_id"))
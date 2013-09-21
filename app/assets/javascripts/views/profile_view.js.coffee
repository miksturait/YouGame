YoutrackGame.ProfileView = Ember.View.extend
  currentMemberBinding: 'YoutrackGame.MembersController.currentMember'
  selectedMemberBinding: 'YoutrackGame.MembersController.selectedMember'
  templateName: "profile"

  member: (->
    @_initKnob()
    @get('selectedMember') || @get('currentMember')
  ).property('selectedMember', 'currentMember')

  _initKnob: ->
    config_exp =
      width:80
      height:80
      thickness: '.25'
      readOnly: true
      fgColor: '#4bb1cf'
      inputColor: '#fff'
      bgColor: '#000'

    config_stamina =
      width:60
      height:60
      thickness: '.25'
      readOnly: true
      fgColor: '#468847'
      inputColor: '#fff'
      bgColor: '#000'
    setTimeout ->
      $('.dossier-progress input').knob(config_exp)
      $('.dossier-stamina input').knob(config_stamina)
    , 1
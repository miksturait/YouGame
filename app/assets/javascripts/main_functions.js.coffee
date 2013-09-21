YoutrackGame.currentPage = null
YoutrackGame.autoMode = null
YoutrackGame.returnFromAuditsTimeout = null

YoutrackGame.sounds =
  notify: new Audio('/sounds/notify.mp3')

if $('#container').length > 0
  $(".ember_nav").show()

YoutrackGame.changePage = (page) ->
  @clearReturnFromAudit()
  $("#container .page").fadeOut('fast');
  setTimeout(->
    $('#container #'+page).fadeIn('fast')
    scrollTo(0,0)
  , 200);
  $("#subnav li").removeClass "active"
  $("#subnav li." + page).addClass "active"
  @currentPage = page

YoutrackGame.clearReturnFromAudit = ->
  clearTimeout(@returnFromAuditsTimeout)

YoutrackGame.showRanking = (type) ->
  YoutrackGame.RankingController.set "rankingType", type
  YoutrackGame.changePage "ranking"
  $('.ranking-submenu li').removeClass('active')
  $('.ranking-submenu li.ranking-'+type).addClass('active')

YoutrackGame.showMyProfile = ->
  @MembersController.set('selectedMember', null)
  @changePage('profile')

YoutrackGame.showIntroVideo = ->
  $video = $('<iframe>', width: 680, height: 380, src: 'http://www.youtube.com/embed/ri7XwoxBkp8?autoplay=1', frameborder: '0', allowfullscreen: true)
  $('.welcome').html($video)
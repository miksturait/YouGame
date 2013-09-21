YoutrackGame = Ember.Application.create();

//= require ./store
//= require_tree ./models
//= require_tree ./controllers
//= require_tree ./views
//= require_tree ./helpers
//= require_tree ./templates
//= require_tree ./routes
//= require ./main_functions
//= require_self

YoutrackGame.initialize();

YoutrackGame.config = Ember.Object.create({
    trackerId: null,
    currentMemberId: null,
    trackedMembersIds: [],
    currentTime: new Date()
});

updateTime = function(){ YoutrackGame.config.set('currentTime', new Date())};
setInterval(updateTime, 60000);

var pusher, updateChannel;

$(document).ready(function(){ initCommonElements() });
YoutrackGame.ready = function(){
    if ($('#container').length > 0) {
        YoutrackGame.ActivityView.create().appendTo('#activity');
        YoutrackGame.RankingView.create().appendTo('#ranking');
        YoutrackGame.AuditView.create().appendTo('#audit');
        YoutrackGame.ProfileView.create().appendTo('#profile');
        YoutrackGame.MissionView.create().appendTo('#mission');
        YoutrackGame.changePage('mission');
        setTimeout(initEmberElements,1);

        pusher = new Pusher(YoutrackGame.pusherKey);
        updateChannel = pusher.subscribe('updates_' + YoutrackGame.config.get('trackerId'));
        updateChannel.bind('make_update', function(data) {
            console.log('** Update requested', new Date());
            $.get('/my/tracker').always(function(data){
                YoutrackGame.DataController.loadData(JSON.parse(data.responseText))
            });
        });
    }
};
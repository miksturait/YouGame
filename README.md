YouGame - gamification with YouTrack
====================================

## Features

* collect minerals and experience points for completing tasks
* get custom achievements assigned by tracker admin
* prepare weekly project reports

## Story

Imagine… The planet Earth is overpopulated and the humankind is compelled to search with hope for new habitats beyond
the solar system. Your co-workers are the engineers of The Last Hope organisation that ensures the settlement of the
selected planets within remote galaxies. As a Spaceship Commander you will help them to save a man kind…

## Development

* Template Engine: Haml and Handlebars
* Testing Framework: RSpec and Factory Girl
* Form Builder: SimpleForm
* Authentication: Devise

### How it works

![How it works](https://github.com/miksturait/YouGame/raw/master/public/how_it_works.png)

### Download and setup application

    git clone git@github.com:miksturait/YouGame.git
    cd YouGame
    bundle install
    cp config/database.yml.example config/database.yml          # configure access to database
    cp config/application.yml.example config/application.yml    # configure access to services
    rake db:create db:migrate

### Mailcatcher

Run ```mailcatcher``` from terminal and then open http://localhost:1080 in browser to browse sent emails

### Synchronizing updates from Youtrack (Pulling data and sending broadcast)

```ruby
RAILS_ENV=development rake daemon:yougame_updater # runs rake not daemonized
RAILS_ENV=development rake daemon:yougame_updater:start # starts updater daemon
RAILS_ENV=development rake daemon:yougame_updater:stop # stops updater daemon
```

## Third-Party Services

* [YouTrack](http://www.jetbrains.com/youtrack/)
* [PusherApp](https://www.pusherapp.com)

## Technology Stack

* Ruby 2.0.0
* Rails 3.2.13
* PostgreSQL  >= 9.0
* EmberJs 0.8
* Redis 3.0.2

## Licence

MIT

## Contributors

* [Tomasz Borowski](http://tbprojects.pl)
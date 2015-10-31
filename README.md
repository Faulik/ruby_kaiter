## Kaitering


### Easy way #1

- `install postgres`
- `install ruby 2.2.3`
- `bundle install --path vendor/bundle`
- `bundle exec rake db:create db:migrate db:seed`
- `bundle exec rake populate:all`
- `bundle exec rails s -b 0.0.0.0`

goto localhost:3000

### Easy way #2

install docker https://github.com/docker/docker

install docker-compose https://github.com/docker/compose/releases

- `docker-compose build`
- `docker-compose up`

goto localhost:3000

* name `web` might change if there are other boxes

### How to run the test suite

- `bundle exec db:create db:migrate RAILS_ENV=test`
- `bundle exec rspec`

or

- `docker-compose run web bundle exec db:create db:migrate RAILS_ENV=test`
- `docker-compose run web bundle exec rspec`

Released under the MIT license
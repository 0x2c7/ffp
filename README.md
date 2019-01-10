# README

- Ruby: 2.3.3
- Rails: 5.2
- Prepare DB and seeds:

```
bundle install
bundle exec rake db:create
bundle exec rake db:migrate
bundle exec rake db:seed
```

- Start web server:

```
bundle exec rails s
```

- Test with 2 test users (or randomly pick in 100 test users. All of the passwords are `password`)
  - `test@test.com`
  - `test2@test.com`

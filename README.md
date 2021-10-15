# README

## Apllication

To run application

```
docker-compose build # Builds project images.
docker-compose up # Boots up the app.
docker-compose run web rake db:create # Create databases.
docker-compose run web rake db:migrate # Run migrations.
```

## Test

If you have already created database and run migrations you can run tests using:

```
docker-compose run web bundle exec rspec
```

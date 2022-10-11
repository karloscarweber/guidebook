# Guidebook

Camping Gear to bring ActiveRecord to your Camping app.

Install using bundler:
```bash
bundle add guidebook
```

Guidebook should now be added as a Gemfile dependency and gem installed. So you can navigate to your Camping app and install it there too. Run this in your shell:
```bash
guidebook install
```

This will generate a `db/` directory, along with a `db/config.kdl`, and a `db/migrate` folder for your migrations. If you have a Rakefile, it will append Code to install database commands to your Rakefile.

You'll need to pack guidebook to get it working in your app:

```ruby
require 'camping'
require 'guidebook'

Camping.goes :MyApp

module MyApp
  pack Camping::GuideBook

  module Models
    class Page < Base; end
  end

  # you'll need to connect to your database in the #create method
  def self.create
    establish_connection()
  end
end
```

## Creating a database

## Connecting to your databse
When you pack `guidebook` into your camping app, guidebook adds an `#establish_connection` method to your camping app. Call this in your `#create` method to connect to your database.

```ruby
module MyApp
  module Models class Page < Base; end  end

  def self.create
    establish_connection()
  end
end
```

## Running some queries.

Just do it!

## Adding Rake tasks to your Rakefile

## Making a new migration

## Running your migration

## Rolling back a migration

### Todo
- [ ] Support database_url, and using environment variables as the database thing.
- [ ] Write a Readme.
- [ ] Add an example Camping App using the Extension.
- [ ] Finish work on Camping 3.0 so that this gem can be used like legit.
- [ ] Write some guides on how to use Active Record.
- [ ] Add copyright thing.
- [ ] Add Feedback to Guidebook Install Command.

### Done
- [x] Add camping as a development dependency.
- [x] Add a Gemfile.
- [x] Get default database locations and config.kdl stuff working too.
- [x] Enter the thing into Git.
- [x] Have a default spot that settings are grabbed from. (/db/config.kdl)
- [x] Have a setting where a database connection string is grabbed by default
- [x] Test that settings added using #set on the Camping app take precedence.
- [x] Generate config.yml for the rake tasks stuff thing. It expects it.
- [x] Write tests with Rake.
- [x] Also test using Rake.
- [x] Write a generator that adds a db/ folder and a db/ config.kdl
- [x] Test the gem with a greenfield project.
- [x] Move the db directory to test, then rewrite the test suite to generate these files.
- [x] Map migration commands to Rake automatically somehow.
- [x] Map Generators to rake somehow too.
- [x] Add config.yml generation to the install sequence.
- [x] Improve Guidebook to NOT add anything to the rake file if cairn is included and the standalone_migrations tasks.

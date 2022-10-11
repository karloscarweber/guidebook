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
Running `guidebook install` should add migration support to your Rakefile.

## Making a new migration
To make a new migration run this in your terminal:
```bash
rake db:new_migration name=MyNewMigration
```
Which should produce:
```ruby
class MyNewMigration < ActiveRecord::Migration[7.0]
  def change
  end
end
```

### Creating a table in the migration
If the migration is named in pattern: `CreateXXX` then the migration will create a new table with the name `XXX`. You can add column names and types to be created as well:
```bash
rake db:new_migration name=CreatePages options=title:string/content:text
```
Which should produce:
```ruby
class CreatePages < ActiveRecord::Migration[7.0]
  def change
    create_table :pages do |t|
      t.string :title
      t.text :content
    end
  end
end
```

### Adding or removing columns from existing tables.
To add or remove columns to tables that already exist You can name your migrations and provide list of columns to do that. Anything named "AddColumnToTable" with some column options, will create a migration adding those columns to that table. Here's an Example:
```bash
rake db:new_migration name=AddCheeseToPages options=cheese:string
```
Which will produce:
```ruby
class AddCheeseToPages < ActiveRecord::Migration[7.0]
  def change
    add_column :pages, :cheese, :string
  end
end
```

If you'd like to remove columns, name it "RemoveColumnFromTable", Here's an example:
```bash
rake db:new_migration name=RemoveCheeseFromPages options=cheese:string
```
Which will produce:
```ruby
class RemoveCheeseFromPages < ActiveRecord::Migration[7.0]
  def change
    remove_column :pages, :cheese, :string
  end
end
```

You can also add an index to a new column:
```bash
rake db:new_migration name=AddUsernameToPages options=username:string:index
```
Which will produce:
```ruby
class AddUsernameToPages < ActiveRecord::Migration[7.0]
  def change
    add_column :pages, :username, :string
    add_index :pages, :username
  end
end
```

You can add multiple columns to the migration

## Running your migration

## Rolling back a migration

### Todo
- [ ] Write a Readme.
- [ ] Support database_url, and using environment variables as the database thing.
- [ ] Add an example Camping App using the Extension.
- [ ] Finish work on Camping 3.0 so that this gem can be used like legit.
- [ ] Write some guides on how to use Active Record.
- [ ] Add copyright thing.
- [ ] Add Feedback to Guidebook Install Command.
- [ ] Test and document generators for migration
- [ ] Test and document migrations.

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

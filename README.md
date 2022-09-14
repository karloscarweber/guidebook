# Guidebook

Camping Gear to bring ActiveRecord to your Camping app.

Install using bundler:
```bash
bundle add guidebook
```

### Todo
- [x] Move the db directory to test, then rewrite the test suite to generate these files.
- [ ] Write a Readme.
- [x] Write a generator that adds a db/ folder and a db/ config.kdl
- [ ] Test the gem with a greenfield project.
- [ ] Add an example Camping App using the Extension.
- [ ] Support database_url, and using environment variables as the database thing.
- [ ] Finish work on Camping 3.0 so that this gem can be used like legit.
- [ ] Map Generators to rake somehow too.
- [ ] Write some guides on how to use Active Record.
- [x] Write tests with Rake.
- [x] Also test using Rake.
- [ ] Map migration commands to Rake automatically somehow.
- [ ] Test Migrations across multiple databases.
- [ ] Add copyright thing.

### Done
- [x] Add camping as a development dependency.
- [x] Add a Gemfile.
- [x] Get default database locations and config.kdl stuff working too.
- [x] Enter the thing into Git.
- [x] Have a default spot that settings are grabbed from. (/db/config.kdl)
- [x] Have a setting where a database connection string is grabbed by default
- [x] Test that settings added using #set on the Camping app take precedence.
- [x] Generate config.yml for the rake tasks stuff thing. It expects it.

### Notes:
It would be cool If we could map Active Record generators to rake tasks automatically from Plugins.

Camping needs a place to mount Command line arguments automagically. migrations is something that needs to be universal and good and stuff.

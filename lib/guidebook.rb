# Begin Guide Book Plugin work...
begin
    require 'active_record'
    require 'sqlite3'
    require 'cairn'
    require 'kdl'
rescue LoadError => e
    raise MissingLibrary, "ActiveRecord could not be loaded (is it installed?): #{e.message}"
end

$AR_TO_BASE = <<-RUBY
  Base = ActiveRecord::Base unless const_defined? :Base
RUBY

module Camping
  module GuideBook

    # ActiveRecordCloser is middleware that closes the connection to the database.
    class ActiveRecordCloser
      def initialize(app)
        @app = app
      end

      def call(env)
        @app.call(env)
      ensure
        conn = ActiveRecord::Base.connection
        conn.close if conn.respond_to?(:close)
      end
    end

    def self.setup(app, *a, &block)
      app.use ActiveRecordCloser

      # Puts the Base Class into your apps' Models module.
      app::Models.module_eval $AR_TO_BASE

      puts "Camping Setup called."

      # The defaults are all for local hosting.
      db_host   = app.options[:db_host]        ||=  'localhost'
      adapter   = app.options[:adapter]        ||=  'sqlite3'
      database  = app.options[:database]       ||=  'db/camping.db'
      pool      = app.options[:pool]           ||=  5

      stored_config = self.get_config # Grab settings in db/config.kdl
      environment = ENV['environment'] ||= "development"

      # Loop through environments set in the config.kdl file.
      # Settings that are set in app.options take precedence to whatever is set
      # in cb/config.kdl Also because defaults are already set above, they are
      # only replaced if there is a value, no value, no replacement.
      case environment
      when "production"
        if stored_config.has_key? :production
          prod = stored_config[:production]
          db_host   = prod[:db_host] if prod.has_key? :db_host
          adapter   = prod[:adapter] if prod.has_key? :adapter
          database  = prod[:database] if prod.has_key? :database
          pool      = prod[:pool] if prod.has_key? :pool
        end
      when "test"
        if stored_config.has_key? :test
          prod = stored_config[:test]
          db_host   = prod[:db_host] if prod.has_key? :db_host
          adapter   = prod[:adapter] if prod.has_key? :adapter
          database  = prod[:database] if prod.has_key? :database
          pool      = prod[:pool] if prod.has_key? :pool
        end
      else "development"
        if stored_config.has_key? :development
          prod = stored_config[:development]
          db_host   = prod[:db_host] if prod.has_key? :db_host
          adapter   = prod[:adapter] if prod.has_key? :adapter
          database  = prod[:database] if prod.has_key? :database
          pool      = prod[:pool] if prod.has_key? :pool
        end
      end

      # Establishes the database connection.
      # Because we're doing all of this in the setup method
      # The connection will take place when this gear is packed.
      app::Models::Base.establish_connection(
        :adapter => adapter,
        :database => database,
        :host => db_host,
        :pool => pool
      )
      # Interesting side effect. If we pack this gear into more than one app,
      # Then each app will have a database connection to manage.
    end

    # #get_config
    # searches for any kdl document inside of a db folder.
    # Then parses it looking for a database node. The Database node
    # contains database settings for different environments.
    # Example syntax:
    #
    #    database {
    #      environment "development" \
    #        adapter="sqlite3" \
    #        database="db/camping.db" \
    #        host="localhost" \
    #        pool=5 \
    #        timeout=5000
    #    }
    #
    # You can also write it like this:
    #
    #    database {
    #      environment "development" adapter="sqlite3" database="db/camping.db" host="localhost" pool=5 timeout=5000
    #      environment "production" adapter="sqlite3" database="db/camping.db" host="localhost" pool=5 timeout=5000
    #    }
    #
    # This can probably be refactored down to something more simple.
    def self.get_config
      files = Dir.glob("**/db/*.kdl")
      config_file = nil
      # try to get the config_file for db.
      files.each do |file|
        f = file.split("/").last
        config_file = file if f == "config.kdl"
      end

      kdl_doc = nil
      if config_file
        kdl_string = File.open(config_file).read
        kdl_doc = KDL.parse_document(kdl_string)
      end

      # database settings dictionary
      db_sets = {}
      if kdl_doc
        kdl_doc.nodes.each do |d|

          # Only care about the database node
          if d.name == "database"
            # parse database
            d.children.each do |en|

              if en.properties.count < 1
                next
              else
                env_name = en.name.to_sym
              end

              # parse the settings for each environment
              db_sets[env_name] = {}
              en.properties.each do |key, value|
                db_sets[env_name][key.to_sym] = value.value
              end
            end
          end

        end
      else
        # puts "No KDL document found"
      end
      db_sets
    end

    # TO DO:
    # [ ] Map migration commands to Rake automatically somehow.
    # [ ] Map Generators to rake somehow too.
    # [x] Have a default spot that settings are grabbed from. (/db/config.kdl)
    # [ ] Have a setting where a database connection string is grabbed by default

    # Notes:
    # It would be cool If we could map Active Record generators to rake tasks
    # automatically from Plugins.
    #
    # Camping needs a place to mount Command line arguments automagically.
    # migrations is something that needs to be universal and good and stuff.
    #

  end
end

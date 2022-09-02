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

    # this is the private settings for database defaults.
    def self.db_defaults
    {
      default: {
        host:  'localhost',
        adapter:  'sqlite3',
        database:  'db/camping.db',
        pool:  5
      }
    }
    end

    def self.setup(app, *a, &block)
      app.use ActiveRecordCloser

      # Puts the Base Class into your apps' Models module.
      app::Models.module_eval $AR_TO_BASE

      stored_config = self.get_config # Grab settings in db/config.kdl

      # Expects an array, hence parallel assignment. Should probably always get one too.
      config_dict = self.squash_settings(app, stored_config)
      environment = ENV['environment'] ||= "development"
      db_host, adapter, database, pool = config_dict[:collapsed_config]

      # does that generatin action!
      generate_config_yml(config_dict[:stored_config])

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

    # squash settings basically collapses all the settings that we have into something
    # truly beautiful.
    def self.squash_settings(app, config)
      defaults = self.db_defaults

      stored_config = config
      environment = ENV['environment'] ||= "development"

      # The defaults are all for local hosting.
      db_host   = defaults[:default][:host]
      adapter   = defaults[:default][:adapter]
      database  = defaults[:default][:database]
      pool      = defaults[:default][:pool]

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
      when "development"
        if stored_config.has_key? :development
          prod = stored_config[:development]
          db_host   = prod[:db_host] if prod.has_key? :db_host
          adapter   = prod[:adapter] if prod.has_key? :adapter
          database  = prod[:database] if prod.has_key? :database
          pool      = prod[:pool] if prod.has_key? :pool
        end
      end

      # Overwrite any settings with directly added app settings.
      db_host   = app.options[:db_host]   ||=  db_host
      adapter   = app.options[:adapter]   ||=  adapter
      database  = app.options[:database]  ||=  database
      pool      = app.options[:pool]      ||=  pool

      { collapsed_config: [db_host, adapter, database, pool], stored_config: stored_config}
    end


    # #get_config
    # searches for any kdl document inside of a db folder.
    # Then parses it looking for a database node. The Database node
    # contains database settings for different environments.
    # Example syntax:
    #
    #    database {
    #     default adapter="sqlite3" database="db/camping.db" host="localhost" pool=5 timeout=5000
    #     development
    #     production adapter="postgres" database=""
    #    }
    #
    # This can probably be refactored down to something more simple.
    def self.get_config

      config_file = self.get_config_file

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

              env_name = en.name.to_sym

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

      # This merges the default data from the config file, or our lib defaults
      # into each environment. If no kdl default is found then our lib defaults
      # are used.
      new_sets, dfault = {}, db_sets[:default] ||= self.db_defaults[:default]
      db_sets.each { |d| new_sets[d[0]] = dfault.merge(d[1]) }
      new_sets
    end

    # parses a kdl file into a kdl document Object.
    # returns nil if it's false. Also assumes that the file is exists.
    def self.parse_kdl(config_file = nil)
      kdl_string = File.open(config_file).read
      kdl_doc = KDL.parse_document(kdl_string)
      kdl_doc
    end

    # get kdl files
    # returns the config file
    # param[search_pattern] is optional, but defaults to look everywhere it can.
    # returns nil if there is nothing to find.
    def self.get_config_file(search_pattern = "**/db/*.kdl")
      # get file location,
      files = Dir.glob(search_pattern)
      config_file = nil
      # try to get the config_file for db.
      files.each do |file|
        f = file.split("/").first
        l = file.split("/").last

        # This logic prioritizes the db/config file in the root directory, This
        # assumes that a Deep search is conducted and that more than one kdl
        # file was found. Otherwise a deep, specific search will probably get
        # the specific file you want.
        if config_file != nil
          cff = config_file.split("/").first
          if f == "db" && cff != "db"
            config_file = file if l == "config.kdl"
          end
        else
          config_file = file if l == "config.kdl"
        end

      end
      config_file
    end

    # Generates a config.yml like a complete badass.
    # necessary for political reasons. Cairn, which depends
    # on standalone-migrations, expects a config.yml in the db/ directory.
    # So we'll generate one. It's only used for running migrations.
    # maybe we'll get rid of this soon.... hope so.
    def self.generate_config_yml(config=nil)

      # Freak out if we config is nil
      raise StandardError, "No database configurations were provided." unless config != nil

      # String_to_write_to_file
      yaml_string = "# db/config.yml \n\n"
      yaml_string << "# This is a generated File. Do not directly alter this file and expect any changes.\n"
      yaml_string << "# Modify db/config.kdl instead. \n"

      # A is a proc to help generate the YAML file.
      add_row = -> (yammy, conf) {
        yaml_string <<  "\n"
        yaml_string <<  "default: \n"
        yaml_string <<  "  adapter: #{conf[:adapter]}\n"   if conf.has_key? :adapter
        yaml_string <<  "  database: #{conf[:database]}\n" if conf.has_key? :database
        yaml_string <<  "  host: #{conf[:host]}\n"      if conf.has_key? :host
        yaml_string <<  "  pool: #{conf[:pool]}\n"         if conf.has_key? :pool
        yaml_string <<  "  timeout: #{conf[:timeout]}\n"   if conf.has_key? :timeout
      }

      if config.has_key? :default
        add_row.(yaml_string, config[:default])
      end

      if config.has_key? :development
        add_row.(yaml_string, config[:development])
      end

      if config.has_key? :production
        add_row.(yaml_string, config[:production])
      end

      # write the thing.
      File.open('db/config.yml', 'w') { |file|
        file.write(yaml_string)
      }
    end

  end
end

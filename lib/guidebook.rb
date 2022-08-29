# Begin Guide Book Plugin work...
begin
    require 'active_record'
    require 'sqlite3'
    require 'cairn'
rescue LoadError => e
    raise MissingLibrary, "ActiveRecord could not be loaded (is it installed?): #{e.message}"
end

$AR_TO_BASE = %{
  Base = ActiveRecord::Base unless const_defined? :Base
}

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

      # The defaults are all for localhosting.
      db_host   = app.options[:db_host]        ||=  'localhost'
      adapter   = app.options[:adapter]        ||=  'sqlite3'
      database  = app.options[:database]       ||=  'db/camping.db'
      pool      = app.options[:database_pool]  ||=  5

      # Establishes the database connection.
      # Because we're doing all of this in the setup method
      # The connection will take place when this gear is packed.
      app::Models::Base.establish_connection(
        :adapter => adapter,
        :database => database,
        :host => db_host,
        :pool => pool
      )
    end

    # TO DO:
    # [] Map migration commands to Rake automatically somehow
    # [] Map Generators to rake somehow too.
    # [] Have a default spot that settings are grabbed from
    # [] Have a setting where a database connection string is grabbed by default

    # Notes:
    # It would be cool If we could map Active Record generators to rake tasks
    # automatically from Plugins.
    #
    # Camping needs a place to mount Command line arguments automagically.
    # migrations is something that needs to be universal and good and stuff.

  end
end

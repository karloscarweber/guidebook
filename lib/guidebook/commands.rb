require 'irb'
require 'optparse'

module Camping
  module GuideBook

    class << self
      def parse
        parse_commands()
      end

      protected

      def parse_commands()
        op_obj = Camping::GuideBook::Options.new
        options, parser, commands = op_obj.options, op_obj.parser, []
        ARGV.each do |cmd|
          commands << cmd
        end

        case commands[0]
        when "install"
          self.create_defaults options
        when "-v" || "--version"
          puts "Guidebook v#{Camping::GuideBook::VERSION}"
          exit
        else
          puts parser
          exit
        end

        exit
      end

      # Create Defaults:
      # Creates, if not present, the following:
      #   a db/ folder
      #   a db/config.kdl file with default settings
      #   a db/migrate folder.
      #
      # Also appends the Cairn bindings for Active Record migrations via Rake.
      # Cairn is just a wrapper for standalone-migrations, so they should all
      # be the same.
      def create_defaults(options)

        dir = "db"

        # This option will change the install directory of the database stuff.
        # The rest of guidebook doesn't know how to find it so this is kinda
        # pointless at the moment.
        if options.has_key? :directory
          puts "directory option was added: #{options[:directory]}"
          dir = options[:directory]
        end

        create_db_folder(dir)
        create_migrate_folder(dir)
        create_config_kdl(dir)
        create_config_yml(dir)
        add_commands_to_rakefile()
      end

      def create_db_folder(dir)
        folder = "#{dir}"
        Dir.mkdir(folder) unless Dir.exist?(folder)
      end

      def create_migrate_folder(dir)
        folder = "#{dir}/migrate"
        Dir.mkdir(folder) unless Dir.exist?(folder)
      end

      def create_config_kdl(dir)
        file = "#{dir}/config.kdl"
        CONFIG_KDL["ddddddd"] = dir
        File.open(file, 'w') { |f| f.write CONFIG_KDL } unless File.exist?(file)
      end

      def create_config_yml(dir)
        file = "#{dir}/config.yml"
        CONFIG_YML["ddddddd"] = dir
        File.open(file, 'w') { |f| f.write CONFIG_YML } unless File.exist?(file)
      end

      def add_commands_to_rakefile()
        File.open('Rakefile', 'a') { |f| f.write("\n#{RAKEFILE_APPENDS}") }
      end

      CONFIG_KDL = <<-TXT
// config.kdl

  database {
    default adapter="sqlite3" database="ddddddd/camping.db" host="localhost" pool=5 timeout=5000
    development
    production
  }
TXT

      CONFIG_YML = <<-TXT
# db/config.yml

  # This is a generated File. Do not directly alter this file and expect any changes.
  # Modify db/config.kdl instead. Then start your app to regenerate this file.

  default:
    adapter: sqlite3
    database: ddddddd/camping.db
    host: localhost
    pool: 5
    timeout: 5000

  development:
    adapter: sqlite3
    database: ddddddd/camping.db
    host: localhost
    pool: 5
    timeout: 5000

  production:
    adapter: sqlite3
    database: ddddddd/camping.db
    host: localhost
    pool: 5
    timeout: 5000

TXT

        RAKEFILE_APPENDS = <<-TXT
# Add database migrations to your Rakefile.
begin
  require "cairn"
  require "guidebook"
  StandaloneMigrations::Tasks.load_tasks
rescue LoadError => e
  puts "gem install cairn to get db:migrate:* tasks! (Error: \#{e})"
end
TXT

    end

    class Options

      # initalizing an Options object grabs the ARGV arguments
      def initialize()
        parse!(ARGV)
      end

      def options
        @options
      end

      def parser
        @parser
      end

      protected

      def parse!(args)
        args = args.dup

        @options = {}
        @options[:version] = false

        opt_parser = OptionParser.new("", 24, '  ') do |opts|
          opts.banner = "Usage: guidebook [command] [options]"
          opts.define_head "Guidebook, Camping Gear to bring ActiveRecord to your Camping app. "
          opts.separator ""
          opts.separator "Specific options:"

          # opts.on("-a", "--add",
          # "Adds a db folder with a migrate folder inside") { |v| options[:Host] = v }
          opts.on("-i", "--install",
          "Installs Guidebook, With default database settings. Adds actions to your Rakefile, ads a config.kdl in your db directory.") {|v| @options[:install] = true}

          opts.on("-d", "--directory [DIRECTORY_NAME]", "changes the installation directory of your database stuff") { |v| @options[:directory] = v }

          opts.on("-v", "--version", "displays the current Guidebook version") { |v| @options[:version] = true }

          # No argument, shows at tail.  This will print an options summary.
          # Try it and see!
          opts.on_tail("-h", "--help", "Show this message") do
            puts opts
            exit
          end

        end
        opt_parser.parse!(args)
        @parser = opt_parser
      end

    end
  end
end



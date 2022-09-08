require 'irb'
require 'optparse'

# OptionParser

module Camping
  module GuideBook

    class << self
      def parse
        options = Camping::GuideBook::Options.new
        parse_commands(options)
      end

      protected

      def parse_commands(options_object)
        options = options_object.options
        parser  = options_object.parser
        commands = []
        ARGV.each do |cmd|
          commands << cmd
        end

        case commands[0]
        when "install"
          puts "Install was selected"
          self.create_defaults
        # when "dookie"
        #   puts "dropped a dookie"
        when "-v" || "--version"
          puts "Guidebook v#{Camping::GuideBook::VERSION}"
          exit
        else
          # puts options
          puts parser
          exit
        end

        if options[:install] == true
          puts "install option was selected"
        end

        if options.has_key? :directory
          puts "directory option was added: #{options[:directory]}"
        end

        exit
      end

      def create_defaults
        create_db_folder
        create_migrate_folder
        create_config_kdl
      end

      def create_db_folder
        folder = 'db'
        Dir.mkdir(folder) unless Dir.exist?(folder)
      end

      def create_migrate_folder
        folder = 'db/migrate'
        Dir.mkdir(folder) unless Dir.exist?(folder)
      end

      def create_config_kdl
        file = 'db/config.kdl'
        File.open(file, 'w') { |f| f.write CONFIG_KDL } unless File.exist?(file)
      end

      CONFIG_KDL = <<-TXT
// config.kdl

  database {
    default adapter="sqlite3" database="db/camping.db" host="localhost" pool=5 timeout=5000
    development
    production
  }
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

      # if home = ENV['HOME'] # POSIX
      #   DB = File.join(home, '.camping.db')
      #   RC = File.join(home, '.campingrc')
      # elsif home = ENV['APPDATA'] # MSWIN
      #   DB = File.join(home, 'Camping.db')
      #   RC = File.join(home, 'Campingrc')
      # else
      #   DB = nil
      #   RC = nil
      # end

      # HOME = File.expand_path(home) + '/'

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



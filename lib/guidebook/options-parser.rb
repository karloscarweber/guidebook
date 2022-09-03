require 'irb'

module Camping
  class GuideBook
    class Options
      if home = ENV['HOME'] # POSIX
        DB = File.join(home, '.camping.db')
        RC = File.join(home, '.campingrc')
      elsif home = ENV['APPDATA'] # MSWIN
        DB = File.join(home, 'Camping.db')
        RC = File.join(home, 'Campingrc')
      else
        DB = nil
        RC = nil
      end

      HOME = File.expand_path(home) + '/'

      def parse!(args)
        args = args.dup

        options = {}

        opt_parser = OptionParser.new("", 24, '  ') do |opts|
          opts.banner = "Usage: guidebook [command] [options]"
          opts.define_head "Guidebook, Camping Gear to bring ActiveRecord to your Camping app. "
          opts.separator ""
          opts.separator "Specific options:"

          # opts.on("-a", "--add",
          # "Adds a db folder with a migrate folder inside") { |v| options[:Host] = v }
          opts.on("-i", "install",
          "Installs Guidebook, With default database settings. Adds actions to your Rakefile, ads a config.kdl in your db directory.") {|v| options[:install] = true}

          # No argument, shows at tail.  This will print an options summary.
          # Try it and see!
          opts.on("-h", "--help", "Show this message") do
            puts opts
            exit
          end
        end

        opt_parser.parse!(args)
      end

    end
  end
end



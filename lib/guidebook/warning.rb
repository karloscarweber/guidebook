module Camping
  module GuideBook

    WARNINGS = []

    def self.kdl_error_message(kdl_string="",error_message="" )
      # parse error message to get line number and column:
      m = error_message.match( /\((\d)+:(\d)\)/ )
      line, column = m[1].to_i, m[2].to_i
      lines = kdl_string.split( "\n" )

      em = "\n"
      em << "#{line-4}: #{lines[line-4]}\n" if (line-4) > 0 && (line-4) < lines.count
      em << "#{line-3}: #{lines[line-3]}\n" if (line-3) > 0 && (line-3) < lines.count
      em << "#{line-2}: #{lines[line-2]}\n" if (line-2) > 0 && (line-2) < lines.count
      em << "#{line-1}: #{lines[line-1]}\n" if (line-1) > 0 && (line-1) < lines.count
      em << "#{line}: #{lines[line]}\n"     if   (line)
      em << "#{line+1}: #{lines[line+1]}\n" if (line+1) > 0 && (line+1) < lines.count
      em << "#{line+2}: #{lines[line+2]}\n" if (line+2) > 0 && (line+2) < lines.count
      em << "#{line+3}: #{lines[line+3]}\n" if (line+3) > 0 && (line+3) < lines.count
      em << "#{line+4}: #{lines[line+4]}\n" if (line+4) > 0 && (line+4) < lines.count
      # em << "\n"
      WARNINGS << em
    end
  end
end
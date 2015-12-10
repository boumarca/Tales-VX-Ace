#==============================================================================
# ** Main
#------------------------------------------------------------------------------
#  This processing is executed after module and class definition is finished.
#==============================================================================
#rgss_main { SceneManager.run }
begin
rgss_main do
    begin
      SceneManager.run
    rescue RGSSReset
      Graphics.transition(10)
      retry
    end
  end
rescue SystemExit
  exit
rescue Exception => error
  scripts_name = load_data('Data/Scripts.rvdata2')
  scripts_name.collect! {|script|  script[1]  }
  backtrace = []
  error.backtrace.each_with_index {|line,i|
    if line =~ /{(.*)}(.*)/
      backtrace << (scripts_name[$1.to_i] + $2)
    elsif line.start_with?(':1:')
      break
    else
      backtrace << line
    end
  }
  error_line = backtrace.first
  backtrace[0] = ''
  print error_line, ": ", error.message, " (#{error.class})", backtrace.join("\n\tfrom "), "\n"
  raise  error.class, "Error ocurred, check the debug console for more information.", [error.backtrace.first]
end
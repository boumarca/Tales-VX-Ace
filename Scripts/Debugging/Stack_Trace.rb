=begin
#===============================================================================
 Title: Script Call Traceback
 Author: Tsukihime
 Date: Aug 3, 2013
--------------------------------------------------------------------------------
 ** Change log
 Aug 3, 2013
   - Initial release
--------------------------------------------------------------------------------   
 ** Terms of Use
 * Free to use in commercial/non-commercial projects
 * No real support. The script is provided as-is
 * Will do bug fixes, but no compatibility patches
 * Features may be requested but no guarantees, especially if it is non-trivial
 * Credits to Tsukihime in your project
 * Preserve this header
--------------------------------------------------------------------------------
 ** Description
 
 This script prints out a more useful traceback when you make script calls.
 Rather than some arbitrary message thrown by the interpreter that something
 went wrong somewhere, you can see exactly why an error occurred. The script
 editor also automatically moves to the line in question.
 
--------------------------------------------------------------------------------
 ** Required
 
 Full Error Backtrace
 (http://himeworks.wordpress.com/2013/06/09/custom-main-full-error-backtrace/)
 
--------------------------------------------------------------------------------
 ** Installation
 
 Place this script below Materials and above Main
 
--------------------------------------------------------------------------------
 ** Usage

 Plug and play.
 Traceback is printed to the console
#===============================================================================
=end
$imported = {} if $imported.nil?
$imported["TH_ScriptCallTraceback"] = true
#===============================================================================
# ** Rest of the script
#===============================================================================
class Object
  #-----------------------------------------------------------------------------
  # Just based on observed behavior. Script calls only have one argument
  # to eval by default so this should be fine until someone finds a reason to
  # pass in more arguments?
  #-----------------------------------------------------------------------------
  alias :th_script_call_traceback_eval :eval
  def eval(*args)
    if args.size == 1
      th_script_call_traceback_eval(args[0], nil, __FILE__, __LINE__)
    else
      return th_script_call_traceback_eval(*args)
    end
  end
end
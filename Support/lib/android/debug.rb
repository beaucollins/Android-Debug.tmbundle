require ENV['TM_SUPPORT_PATH'] + '/lib/escape.rb'
require 'android/jdb'
require 'android/manifest'

module Android::Debug
  # executes a series of commands
  def self.run(dir, options = {})
    @device = options[:device] || "-d"
    @port = options[:port] || "7777"
    
    total = Android::Jdb.make dir
    manifest = Android::Manifest.dir dir
    
    puts "<title>Anrdoid Debug</title>"
    _p "Created #{total} breakpoint#{"s" unless total == 1}"
    _p "Launching #{manifest.package} in debug mode"
    # launch the app with adb
    `adb #{@device} shell am force-stop #{manifest.package}`
    `adb #{@device} shell am start -D -a android.intent.activity.MAIN -n #{manifest.package}/#{manifest.main_activity}`
    # forward the port
    port = `adb #{@device} jdwp | tail -1`
    `adb #{@device} forward tcp:#{@port} jdwp:#{port}`

    _p "Launching jdb in terminal"

    launch_jdb = <<-APPLESCRIPT
        tell application "Terminal"
          activate
          do script "cd #{e_as(e_sh(dir))}; clear; jdb -sourcepath src -attach localhost:#{@port};"
        end tell
    APPLESCRIPT

    open("|osascript", "w") {|io| io << launch_jdb }
    
  end

  def self._p(str)
    puts "<p>#{str}</p>"
  end

end


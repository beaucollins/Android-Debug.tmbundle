require 'rexml/document'
require 'rexml/xpath'
require 'pathname'

require ENV['TM_SUPPORT_PATH'] + '/lib/escape.rb'

class Android::Manifest
  MANIFEST_NAME="AndroidManifest.xml"
  def self.dir(dir)
    # Read in the manifest
    path = Pathname.new(dir).join(MANIFEST_NAME)
    new path
  end
  attr_reader :document
  def initialize(path)
    # read in the  manifest XML
    @document = REXML::Document.new File.open(path, 'r')
  end
  
  def package
    @document.root.attribute 'package'
  end
  
  def main_activity
    activity = REXML::XPath.first @document.root, '//action[@android:name="android.intent.action.MAIN"]/../../'
    activity.attribute "name", "android" if activity
  end
  
end
# First step is to generate the .jdbrc

module Android::Jdb
  # Create a .jdbrc file with breakpoints from bookmarks in Textmate
  # Uses xattr to find com.macromates.bookmarks associated with a given file
  def self.make(dir)
    # find all bookmarks in src/
    breakpoints = 0
    src = dir + '/src'
    bookmarks = `xattr -pr com.macromates.bookmarks #{src} 2> /dev/null`

    # convert bookmarks to .jdrbc
    line_reg = /([^:]+):[\s]+\(([^)]+)\)/
    package_reg = /package (.*);$/

    File.open '.jdbrc', 'w' do |jdbrc|
      bookmarks.split("\n").each do |source_file|
        match = line_reg.match source_file
        lines = match[2].split(',').collect { |n| n.strip[1..-2] }
        File.open match[1], 'r' do |file|
          package = package_reg.match(file.read)[1]
          cls = File.basename(match[1], '.java')
          lines.each do |number|
            breakpoints += 1
            jdbrc << "stop at #{package}.#{cls}:#{number}\n"
          end
        end
      end
    end
    breakpoints
  end
end

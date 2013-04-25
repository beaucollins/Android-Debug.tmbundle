require "#{ENV["TM_SUPPORT_PATH"]}/lib/tm/executor"

module Android::Debug
  # executes a series of commands
  def self.run
    puts "We should run now :) #{TextMage::Executor.class}"
  end
  
end
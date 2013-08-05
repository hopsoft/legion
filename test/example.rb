require "legion"

class Example < Legion::Object
  before(:work) { puts "before work" }

  def work(index)
    puts "working on: #{index}"
    sleep 2
  end
end

def run_example
  supervisor = Legion::Supervisor.new(Example, processes: 7, port: 52042)
  supervisor.start
  1000.times { |i| supervisor.work(i) }
  supervisor.stop
end

run_example


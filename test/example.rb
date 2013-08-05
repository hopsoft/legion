require_relative "../lib/legion"

class Example < Legion::Object

  def work(index)
    sleep 2
  end

  before :work do
    puts "before work"
  end

end

def run_example
  supervisor = Legion::Supervisor.new(Example, processes: 7)
  supervisor.start_remote_instances(port: 42042)

  1000.times do |i|
    worker = supervisor.get_remote_instance
    worker.work_async(i)
    puts i
  end

  supervisor.stop_remote_instances
end

run_example


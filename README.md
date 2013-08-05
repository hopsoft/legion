### True concurrent processing power made easy... even for MRI

Legion leverages distibuted Ruby (DRb) & threads to provide concurrent processing power.

* Works for all Rubies (including MRI)
* Takes care of the heavy lifting for you
* Lets you focus on business needs

## Quick Start

Desgin a class that will perform a single task concurrently.

```ruby
class Worker < Legion::Object

  # our single task
  # - can be named anything you like
  # - can take as many args as you like
  def work
    # expensive operations & logic
  end

  # runs before each method invocation
  before :work do
    # do things like datbase reconnects etc...
  end

end
```

Use the Legion::Object defined above.

```ruby
def work_fast
  supervisor = Legion::Supervisor.new(Worker, processes: 7)
  supervisor.start_remote_instances(port: 42042)

  1000.times do |i|
    worker = supervisor.get_remote_instance
    worker.work_async
  end

  supervisor.stop_remote_instances
end
```


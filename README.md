# Legion

[![Dependency Status](https://gemnasium.com/hopsoft/legion.png)](https://gemnasium.com/hopsoft/legion)
[![Code Climate](https://codeclimate.com/github/hopsoft/legion.png)](https://codeclimate.com/github/hopsoft/legion)

### Concurrent processing made easy... even for MRI

Legion leverages distibuted Ruby (DRb) & threads to provide real concurrency.

* Works for all Rubies (including MRI)
* Takes care of the heavy lifting for you
* Lets you focus on business logic

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
  supervisor = Legion::Supervisor.new(Worker, processes: 7, port: 42042)
  supervisor.start

  1000.times do |i|
    worker = supervisor.work # the supervisor asynchronously delegates to the worker
  end

  supervisor.stop
end
```


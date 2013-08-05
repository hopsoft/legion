# Legion

[![Dependency Status](https://gemnasium.com/hopsoft/legion.png)](https://gemnasium.com/hopsoft/legion)
[![Code Climate](https://codeclimate.com/github/hopsoft/legion.png)](https://codeclimate.com/github/hopsoft/legion)

### Concurrent processing made easy

Legion leverages distibuted Ruby (DRb) & threads to provide real concurrency.

* Works with all Rubies (including MRI)
* Works within Rails & other frameworks
* Takes care of the heavy lifting for you
* Lets you focus on business logic

*Requires Ruby 2.0*

## Quick Start

Create a class that performs a single task.

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
    # db reconnect, etc...
  end

end
```

Use a supervisor to perform work concurrently.

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

## Demo

The demo runs the code in [this file](https://github.com/hopsoft/legion/blob/master/bin/legion_demo).

```
gem install legion
legion_demo
```


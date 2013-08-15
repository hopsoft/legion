# Legion

[![Dependency Status](https://gemnasium.com/hopsoft/legion.png)](https://gemnasium.com/hopsoft/legion)
[![Code Climate](https://codeclimate.com/github/hopsoft/legion.png)](https://codeclimate.com/github/hopsoft/legion)

### Concurrent processing made easy

Legion leverages distibuted Ruby (DRb) & threads to provide real concurrency.

* True concurrency with MRI
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
    supervisor.work # the supervisor asynchronously delegates to the worker
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

## How it Works

### Legion::Object

Legion::Objects know how to create remote instances of themselves.
They do this by forking the main process then starting a DRb server backed by themselves.

![Legion::Object](https://raw.github.com/hopsoft/legion/master/doc/object.png)

### Legion::Supervisor

Legion::Supervisors wrap a Legion::Object and provide helper methods for managing a cluster of remote objects.
For example, starting a cluster & shutting one down.
The supervisor also delegates method calls to the cluster.

![Legion::Object](https://raw.github.com/hopsoft/legion/master/doc/supervisor.png)


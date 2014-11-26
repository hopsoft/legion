[![Lines of Code](http://img.shields.io/badge/lines_of_code-120-brightgreen.svg?style=flat)](http://blog.codinghorror.com/the-best-code-is-no-code-at-all/)
[![Code Status](http://img.shields.io/codeclimate/github/hopsoft/legion.svg?style=flat)](https://codeclimate.com/github/hopsoft/legion)
[![Dependency Status](http://img.shields.io/gemnasium/hopsoft/legion.svg?style=flat)](https://gemnasium.com/hopsoft/legion)

# Legion

### Parallel processing made easy

Legion leverages distibuted Ruby (DRb) & threads to give you concurrency & parallel computing power.

__NOTE__: Requires Ruby 2.0

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

  # runs after the new process has been forked and
  # after DRb has been started (exposing the object as a service)
  after_fork do
    # db reconnect, etc...
  end
end
```

Use a supervisor to perform work in parallel.

```ruby
supervisor = Legion::Supervisor.new(Worker, processes: 7, port: 42042)
supervisor.start

1000.times do |i|
  supervisor.work # the supervisor asynchronously delegates to the worker
end

supervisor.stop
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

Supervisors perform the following operations.

- Start & stop the cluster of remote objects
- Delegate messages (i.e. method calls) to the cluster

![Legion::Object](https://raw.github.com/hopsoft/legion/master/doc/supervisor.png)

### Async Method Invocation

Legion::Objects implicitly create async versions of all defined methods.
These async methods delegate to the real method on another thread and return immediately.
The Legion::Object is considered __busy__ while the background thread is working.

Legion::Supervisors respond to any methods defined on the wrapped Legion::Object.
The distinction being that they asynchronously delegate method calls to the cluster.

![Legion::Object](https://raw.github.com/hopsoft/legion/master/doc/async.png)

The supervisor delegates work to the first idle Legion::Object it identifies.
If all objects are busy, the supervisor will block & wait.


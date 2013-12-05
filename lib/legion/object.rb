require "drb"
require "monitor"
require "socket"

module Legion
  class Object
    include MonitorMixin

    class << self
      def method_added(name)
        return if name =~ /_async\z/i
        define_method "#{name}_async" do |*args|
          Thread.new do
            synchronize { @busy = true }
            send(name, *args)
            synchronize { @busy = false }
          end
        end
      end

      def after_fork(&block)
        @after_fork = block
      end

      def fork_callback
        @after_fork ||= lambda {}
      end
    end

    attr_reader :pid, :uri

    def ok?
      true
    end

    def busy?
      !!@busy
    end

    def start_remote_instance(port: nil)
      return unless pid.nil?
      @uri = "druby://localhost:#{port}"
      @pid = fork do
        DRb.start_service uri, self
        self.class.fork_callback.call
        DRb.thread.join
      end
      Process.detach pid
    end

    def exit
      DRb.stop_service
    end

  end
end

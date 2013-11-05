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
            self.class.callbacks[:before][name].call unless self.class.callbacks[:before][name].nil?
            send(name, *args)
            synchronize { @busy = false }
          end
        end
      end

      def callbacks
        @callbacks ||= {before: {}}
      end

      def before(name, &block)
        callbacks[:before][name] = block
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
        DRb.thread.join
      end
      Process.detach pid
    end

    def exit
      DRb.stop_service
    end

  end
end

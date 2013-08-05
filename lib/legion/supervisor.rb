require "drb"

module Legion
  class Supervisor
    attr_reader(
      :klass,
      :processes,
      :port,
      :local_instances,
      :remote_instances
    )

    def initialize(klass, processes: 1, port: 42042)
      @klass = klass
      @processes = processes
      @port = port
      @local_instances = []
      @remote_instances = []
    end

    def start
      DRb.start_service
      (1..processes).each do |i|
        local_instance = klass.new
        local_instance.start_remote_instance(port: port)
        @port += 1
        local_instances << local_instance
        remote_instance = DRbObject.new_with_uri(local_instance.uri)
        verify_remote_instance(remote_instance)
        remote_instances << remote_instance
      end
    end

    def stop
      remote_instances.each { |inst| inst.exit }
      DRb.stop_service
    end

    def get_remote_instance
      @index ||= 0
      remote_instance = remote_instances[@index]
      sleep 0.01 while remote_instance.busy?
      @index += 1
      @index = 0 if @index >= remote_instances.length
      remote_instance
    end

    def method_missing(name, *args)
      get_remote_instance.send("#{name}_async", *args)
    end

    def respond_to?(name)
      return true if super
      klass.instance_methods.include? name.to_sym
    end

    protected

    def verify_remote_instance(remote_instance)
      ok = false
      while !ok
        begin
          ok = remote_instance.ok?
        rescue DRb::DRbConnError
          sleep 0.1
        end
      end
      ok
    end

  end
end

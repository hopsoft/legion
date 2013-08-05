require "drb"

module Legion
  class Supervisor
    attr_reader(
      :klass,
      :processes,
      :local_instances,
      :remote_instances
    )

    def initialize(klass, processes: 1)
      @klass = klass
      @processes = processes
      @local_instances = []
      @remote_instances = []
    end

    def start_remote_instances(port: nil)
      DRb.start_service
      (1..processes).each do |i|
        local_instance = klass.new
        local_instance.start_remote_instance(port: port)
        port += 1
        local_instances << local_instance
        remote_instance = DRbObject.new_with_uri(local_instance.uri)
        verify_remote_instance(remote_instance)
        remote_instances << remote_instance
      end
    end

    def stop_remote_instances
      remote_instances.each do |remote_instance|
        remote_instance.exit rescue nil
      end
      DRb.stop_service
    end

    def get_remote_instance
      @remote_instance_index ||= 0
      remote_instance = remote_instances[@remote_instance_index]
      sleep 0.01 while remote_instance.busy?
      @remote_instance_index += 1
      @remote_instance_index = 0 if @remote_instance_index >= remote_instances.length
      remote_instance
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

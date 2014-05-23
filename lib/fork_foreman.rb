class ForkForeman
  attr_reader :pids

  def initialize(debug = false)
    @debug = debug
    @pids = {}
  end

  def spawn_process(name, cmd)
    kill_if_exists(name)
    @pids[name] = pid = fork { exec(cmd) }
    log("Spawned #{ name } at #{ pid }")
    Process.detach(pid)
  end

  def kill_if_exists(name)
    begin
      return unless pid = @pids[name]
      log("Attempting to kill '#{ name }' which is: #{ pid.inspect }")
      Process.kill('SIGTERM', pid) if pid
    rescue Errno::ESRCH => e
      # We do not care if it is already dead
      log("Process at #{ pid.inspect } is already dead")
    rescue Exception => e
      # Maybe care about some other error here
      log("ERROR: #{ e.class }: #{ e.message }")
    ensure
      @pids[name] = nil
    end
  end

  def log(msg)
    puts msg if @debug
  end
end


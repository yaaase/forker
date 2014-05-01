class Forker
  def initialize
    @pids = {}
  end

  def spawn_process(name, cmd)
    kill_if_exists(name)
    @pids[name] = pid = fork { exec(cmd) }
    puts "pid: #{ pid } ... ps: #{ `ps xau | grep -i #{ pid }` }"
    Process.detach(pid)
  end

  def kill_if_exists(name)
    begin
      pid = @pids[name]
      return unless pid
      puts "Attempting to kill '#{ name }' which is: #{ pid.inspect }"
      Process.kill('SIGTERM', pid) and Process.wait(pid) if pid
    rescue Errno::ECHILD => e
      nil
    rescue Exception => e
      puts "ERROR: #{ e.class }: #{ e.message }"
    ensure
      @pids[name] = nil
    end
  end
end

def loop_test(cmd1, cmd2)
  5.times { puts }
  f = Forker.new
  puts "spawning cmd1"
  f.spawn_process('mark', cmd1)
  sleep(25)
  puts "spawning cmd2"
  f.spawn_process('mark', cmd2)
  sleep(25)
  f.kill_if_exists('mark')

  puts 'exiting loop_test'
  puts "Forker pids: #{ f.instance_variable_get(:@pids).inspect }"
end

cmd1 = 'while true; do echo first_command; sleep 5; done'
cmd2 = 'while true; do echo second_command; sleep 5; done'

loop_test(cmd1, cmd2)

cmd1 = 'echo first_command; sleep 1; echo first_command'
cmd2 = 'echo second_command; sleep 40; echo second_command'

loop_test(cmd1, cmd2)


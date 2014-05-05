require_relative 'lib/fork_foreman'

def loop_test(cmd1, cmd2)
  5.times { puts }
  f = ForkForeman.new(true)
  puts "spawning cmd1"
  f.spawn_process('mark', cmd1)
  sleep(25)
  puts "spawning cmd2"
  f.spawn_process('mark', cmd2)
  sleep(25)
  f.kill_if_exists('mark')

  puts 'exiting loop_test'
  puts "Forker pids: #{ f.pids.inspect }"
end

# TODO write some fucking unit tests

if ARGV[0] == 'manual_test'
  cmd1 = 'while true; do echo first_command; sleep 5; done'
  cmd2 = 'while true; do echo second_command; sleep 5; done'

  loop_test(cmd1, cmd2)

  cmd1 = 'echo first_command; sleep 1; echo first_command'
  cmd2 = 'echo second_command; sleep 40; echo second_command'

  loop_test(cmd1, cmd2)
end

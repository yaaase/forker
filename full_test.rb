require_relative 'lib/file_monitor'
require_relative 'lib/fork_foreman'

def command(file)
  "while true; do echo 'ForkForeman process for #{ file }'; sleep 5; done"
end

system('touch ~/fork/monitor/one; touch ~/fork/monitor/two; touch ~/fork/monitor/three')

fm = FileMonitor.new(File.join(Dir.pwd, 'monitor'))
ff = ForkForeman.new(true)

fm.files.each { |f| ff.spawn_process(f, command(f)) }

loop do
  if fm.changes?
    puts "FileMonitor has detected changes: #{ fm.changes.inspect }"
    puts "Respawning processes..."
    fm.changes.each { |f| ff.spawn_process(f, command(f)) }
    fm.baseline!
  end

  sleep(5)
  puts "(end of loop)"
end


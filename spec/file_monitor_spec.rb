require_relative '../lib/file_monitor'

describe FileMonitor do
  before(:each) { %x(mkdir -p ~/forker/monitor); @fm = FileMonitor.new(File.join(Dir.pwd, 'monitor')) }
  after(:each)  { system('rm -f ~/forker/monitor/*') }

  it 'monitors a directory in order to observe new files' do
    system('touch ~/forker/monitor/sample_file')
    @fm.changes?.should be_true
  end

  it 'can accept a new baseline' do
    system('touch ~/forker/monitor/sample_file')
    @fm.baseline!
    @fm.changes?.should be_false
    system('touch ~/forker/monitor/sample_file_two')
    @fm.changes?.should be_true
  end

  it 'is not thrown off by repeated editing of the same file' do
    system('touch ~/forker/monitor/sample_afile')
    system('touch ~/forker/monitor/sample_file')
    system('touch ~/forker/monitor/sample_zfile')
    @fm.baseline!

    system('touch ~/forker/monitor/sample_file')
    @fm.changes?.should be_false
  end

  it 'knows which files are new' do
    system('touch ~/forker/monitor/new_file')
    @fm.changes?.should be_true
    @fm.changes.should eq ['new_file']
  end
end


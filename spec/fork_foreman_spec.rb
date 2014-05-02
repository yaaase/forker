require_relative '../lib/fork_foreman'

describe ForkForeman do
  before(:each) { @ff = ForkForeman.new }

  describe 'spawn_process' do
    it 'calls fork, exec and detach' do
      name, cmd = 'mark', ''
      expect(@ff).to receive(:fork).and_return(123)
      expect(@ff).to receive(:kill_if_exists).with(name)
      Process.stub(:detach)
      @ff.spawn_process(name, cmd)
    end
  end

  describe 'kill_if_exists' do
    it 'calls Process#kill if it finds a pid' do
      name, pid = 'mark', 123
      @ff.instance_variable_set(:@pids, { name => pid })
      expect(Process).to receive(:kill).with('SIGTERM', pid)
      @ff.kill_if_exists(name)
      @ff.pids[name].should be_nil
    end
  end
end


require_relative '../core/array'

class FileMonitor
  attr_reader :files, :changes

  def initialize(dir)
    @dir = dir
    baseline!
  end

  def changes?
    @changes = @files ^ get_entries(@dir)
    @changes.any?
  end

  def baseline!
    @changes = nil
    @files = get_entries(@dir)
  end

  private

  def get_entries(dir)
    Dir.entries(dir).reject { |entry| entry =~ /^\./ }.sort
  end

end


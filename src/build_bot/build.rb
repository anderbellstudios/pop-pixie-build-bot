class Build < Struct.new(:platform, :dir, keyword_init: true)
  def clean_up
    FileUtils.rm_rf(dir.path)
  end

  def mv(destination_path)
    FileUtils.mv(dir.path, destination_path)
    self.dir = Dir.new(destination_path)
  end
end

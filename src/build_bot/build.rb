class Build < Struct.new(:platform, :dir, keyword_init: true)
  def clean_up
    FileUtils.rm_rf(dir)
  end

  def mv(destination_path)
    FileUtils.mv(dir, destination_path)
    self.dir = destination_path
  end
end

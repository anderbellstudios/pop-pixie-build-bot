class Build < Struct.new(:platform, :dir, keyword_init: true)
  def clean_up
    FileUtils.rm_rf(dir.path)
  end
end

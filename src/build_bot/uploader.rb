class Uploader
  def upload(file, platform:)
    relative_path = File.join(platform.to_s, File.basename(file))

    system(
      'scp',
      file,
      Environment.fetch(:SCP_HOST) + ':' + quote(
        File.join(Environment.fetch(:SCP_TARGET_PREFIX), relative_path)
      ),
    )

    return File.join(Environment.fetch(:WWW_URL_PREFIX), relative_path)
  end

  private

  def quote(string)
    "\"#{string}\""
  end
end

require 'zip'

class Zipper
  def zip(dir, game_name:)
    source_files = Dir.glob(File.join(dir, '**', '*'))

    File.join(dir, "#{game_name}.zip").tap do |zip_file|
      File.unlink(zip_file) if File.exist?(zip_file)

      Zip::File.open(zip_file, Zip::File::CREATE) do |zip|
        source_files.each do |file|
          # The first argument is the path the file will appear as in the zip file.
          # String#sub is used to transform /big/long/path/my_file to #{game_name}/my_file
          zip.add(file.sub(dir, game_name), file)
        end
      end
    end
  end
end

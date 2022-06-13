require_relative 'test_helper'

class ZipperTest < TestCase
  setup do
    @zipper = Zipper.new

    @test_dir = Dir.mktmpdir

    @source_dir = File.join(@test_dir, 'source')
    Dir.mkdir(@source_dir)
    File.write(File.join(@source_dir, 'my_file'), 'Hello world')

    @output_dir = File.join(@test_dir, 'output')
    Dir.mkdir(@output_dir)

    old_path = @zipper.zip(@source_dir, game_name: 'my_game')
    @zip_file = File.join(@output_dir, File.basename(old_path))
    FileUtils.mv(old_path, @zip_file)
  end

  teardown do
    FileUtils.rm_rf(@test_dir)
  end

  test 'names the zip file after the game name' do
    assert_equal 'my_game.zip', File.basename(@zip_file)
  end

  test 'forms the correct zip structure' do
    Dir.chdir(@output_dir) do
      system "unzip #{@zip_file} > /dev/null"
    end

    assert_equal 'Hello world', File.read(File.join(@output_dir, 'my_game', 'my_file'))
  end
end

require File.expand_path('../test_helper', __FILE__)

scope do
  def mock_cache(name)
    path = File.join(Monk.cache_path, name)
    Monk.git_clone 'git://github.com/x/y', path
  end

  setup do
    Dir[File.join(Monk.cache_path, '*')].each { |path| FileUtils.rm_rf path }
  end

  test 'init fail' do
    monk 'init'
    assert_invalid
  end

  test 'init fail 2' do
    monk 'init x y z'
    assert_invalid
  end

  test 'init git' do
    monk 'init x'
    assert_successful_init 'x'
  end

  test 'init cached' do
    mock_cache 'default'

    monk 'init x'
    assert_successful_init 'x'

    monk 'init x'
    assert cerr.include?('exists')
  end

  test 'init caching' do
    monk 'init x'
    assert_successful_init 'x'
    assert cout.include?('git clone')

    assert File.directory?(Monk.cache_path('default'))

    monk 'init x'
    assert !cout.include?('git clone')
  end

  test 'custom skeleton' do
    monk 'add shivers git://github.com/a/b'
    monk 'init x -s shivers'

    assert_successful_init 'x'
    assert cout.include?('git://github.com/a/b')
  end

  test 'invalid skeleton' do
    monk 'init x -s scabs'
    assert cerr.include?('No such skeleton')
  end

  # TODO: git fail test
end

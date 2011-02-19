require File.expand_path('../test_helper', __FILE__)

scope do
  test 'gem 1' do
    name, ver = Monk.parse_gem_line('nest -v0.1')
    assert [name, ver] == ["nest", "0.1"]
  end

  test 'gem 2' do
    name, ver = Monk.parse_gem_line('nest')
    assert [name, ver] == ["nest", nil]
  end

  test 'gem 3' do
    name, ver = Monk.parse_gem_line('redis -v 0.4')
    assert [name, ver] == ["redis", "0.4"]
  end

  test 'gem 4' do
    name, ver = Monk.parse_gem_line('thor --version 0.5')
    assert [name, ver] == ["thor", "0.5"]
  end

  test 'gem 5' do
    name, ver = Monk.parse_gem_line('thor --version ">= 0.5"')
    assert [name, ver] == ["thor", ">= 0.5"]
  end

  test 'gem 6' do
    name, ver = Monk.parse_gem_line('rack -v "~> 0.6"')
    assert [name, ver] == ["rack", "~> 0.6"]
  end
end

require File.expand_path('../test_helper', __FILE__)

scope do
  test 'add fail' do
    monk 'add'
    assert_invalid
  end

  test 'add fail 2' do
    monk 'add x y z'
    assert_invalid
  end

  test 'add success' do
    monk 'add foobar git://github.com/y'
    assert cerr.include?('Added skeleton')

    monk 'list'
    assert cout =~ /foobar +git:\/\/github.com\/y/
  end

  test 'update' do
    monk 'add foobar git://github.com/y'
    assert cerr.include?('Added skeleton')

    monk 'add foobar git://github.com/z'
    assert cerr.include?('Updated skeleton')

    monk 'list'
    assert cout =~ /foobar +git:\/\/github.com\/z/
  end

  test 'add remove add' do
    monk 'add foobar git://github.com/y'
    assert cerr.include?('Added skeleton')

    monk 'rm foobar'
    assert cerr.include?('Removed')

    monk 'add foobar git://github.com/y'
    assert cerr.include?('Added skeleton')
  end

  test 'remove' do
    monk 'rm foobar'
    assert cerr.include?('No such skeleton')
  end
end

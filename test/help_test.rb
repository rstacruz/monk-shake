require File.expand_path('../test_helper', __FILE__)

scope do
  test 'invalid command' do
    monk 'shivers'
    assert cout.empty?
    assert cerr.include?('Invalid command')
  end

  test 'monk no args' do
    monk 'help'
    err = cerr

    monk ''
    assert err == cerr
  end

  test 'help' do
    monk 'help'

    assert cerr.include?('Usage:')
    assert cerr.include?('www.monkrb.com')

    %w(help version).each { |c| assert cerr.match(/^  #{c}/) }
    %w(init add rm purge list).each { |c| assert cerr.match(/^  #{c}/) }
    %w(unpack lock install).each { |c| assert !cerr.match(/^  #{c}/) }
  end

  test 'help in project' do
    FileUtils.touch 'Monkfile'
    monk 'help'

    assert cerr.include?('Usage:')

    %w(help version).each { |c| assert cerr.match(/^  #{c}/) }
    %w(init add rm purge list).each { |c| assert !cerr.match(/^  #{c}/) }
    %w(unpack lock install).each { |c| assert cerr.match(/^  #{c}/) }
  end
end

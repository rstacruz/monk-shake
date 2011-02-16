require File.expand_path('../test_helper', __FILE__)

scope do
  test 'lock' do
    monk 'lock'
    assert cerr.include?('You need RVM')
  end

  scope do
    prepare do
      $has_rvm = true
    end

    test 'lock rvm' do
      monk 'lock'
      assert rvm_commands.include?('gemset export .gems')
    end

    test 'backup gems' do
      FileUtils.touch '.gems'
      monk 'lock'
      assert cout.include?('moving aside to preserve')
      assert Dir['.gems.*'].any?
      assert rvm_commands.include?('gemset export .gems')
    end
  end
end

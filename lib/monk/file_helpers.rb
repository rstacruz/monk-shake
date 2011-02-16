module Monk::FileHelpers
  # File helpers
  def touch(target)
    say_status :touch, target
    FileUtils.touch target
  end

  def mkdir_p(target)
    return  if File.directory?(target)
    say_status :mkdir, target
    FileUtils.mkdir_p target
  end

  def cp_r(from, target)
    say_status :copy, "#{from} -> #{target}"
    FileUtils.cp_r from, target
  end

  def mv(from, target)
    say_status :move, "#{from} -> #{target}"
    FileUtils.mv from, target
  end

  def rm_rf(target)
    say_status :delete, target
    FileUtils.rm_rf target
  end
end

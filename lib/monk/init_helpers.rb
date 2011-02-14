module Monk::InitHelpers
  def cache_path(name=nil)
    fx "~/.cache/monk", name
  end

  def directory_with_files?(path)
    File.directory?(path) and Dir[File.join(path, '{.*,*}')].any?
  end

  # Cache skeleton files into ~/.cache/monk/default
  def cache_skeleton(name)
    repo = config.skeletons[name]  or return

    path = cache_path(name)
    return path  if directory_with_files?(path)

    mkdir_p fx(path, '..')

    git_clone repo, path

    if $?.to_i != 0
      rm_rf path
      return nil
    end

    rm_rf File.join(path, '.git')

    path
  end

  def git_clone(repo, path)
    system "git clone --depth 1 #{repo} #{path}"
  end
end

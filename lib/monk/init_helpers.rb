module Monk::InitHelpers
  def cache_path(name)
    fx "~/.cache/monk/#{name}"
  end

  def directory_with_files?(path)
    File.directory?(path) and Dir[File.join(path, '{.*,*}')].any?
  end

  # Cache skeleton files into ~/.cache/monk/default
  def cache_skeleton(name)
    path = cache_path(name)

    return path  if directory_with_files?(path)

    mkdir_p path

    system "git clone --depth 1 -q #{repo} #{cache_path}"
    pass  unless $?.to_i == 0

    rm_rf File.join(cache_path, '.git')
  end
end

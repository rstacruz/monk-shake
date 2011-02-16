module Monk::RvmHelpers
  def rvm?
    @has_rvm = (!! `rvm` rescue false)  if @has_rvm.nil?
    @has_rvm
  end

  # Returns the name of the current RVM gemset.
  def rvm_gemset
    File.basename(`rvm current`.strip)
  end

  def rvm_ruby_version
    rvm_gemset.split('@').first
  end

  def rvm(cmd, options={})
    return `rvm #{cmd}`  if options[:output]
    system "rvm #{cmd}"
  end

  def ensure_rvm
    return true  if rvm?
    err "You need RVM installed for this command."
    err "See http://rvm.beginrescueend.com for more info."
  end
end

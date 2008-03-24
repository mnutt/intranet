standard_dirs = ['rails', 'plugins']
gems          = Dir["vendor/**"]
if gems.any?
  gems.each do |dir|
    next if standard_dirs.include?(File.basename(dir))
    lib = File.join(RAILS_ROOT, dir, 'lib')
    $LOAD_PATH.unshift(lib) if File.directory?(lib)
  end
end
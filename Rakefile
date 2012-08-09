task :default do
  sh 'rspec spec'
end

desc "Prepare archive for deployment"
task :archive do
  sh 'zip -r ~/sideways.zip autoload/ doc/sideways.txt plugin/'
end

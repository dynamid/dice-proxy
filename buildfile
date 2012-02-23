Buildr.settings.build['scala.version'] = '2.9.1'
require 'buildr/scala'

repositories.remote << 'http://repo1.maven.org/maven2/'
repositories.remote << 'http://www.ibiblio.org/maven2'
repositories.remote << 'http://maven.twttr.com/'

FINAGLE = "com.twitter:finagle-http_#{Scala.version}:jar:1.11.1"

define 'finagle-test' do    
  project.group = 'my.app'
  project.version = '0.1'
  
  package :jar
  manifest['Main-Class'] = 'my.app.MyApp'
  
  compile.with transitive(FINAGLE)
end

task :execute => :package do
  classpath = transitive(FINAGLE).map { |dep| dep.name }.delete_if { |dep| dep.include? 'scala-library' }.join(':')
  puts "\nRun >>> \n\n"
  sh "scala -cp #{classpath}:target/finagle-test-0.1.jar my.app.MyApp"
end
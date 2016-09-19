Gem::Specification.new do |s|
  s.name        = 'tiledenticon'
  s.version     = '0.1.1'
  s.date        = '2016-09-18'
  s.summary     = "Tiledenticon"
  s.description = "More interesting identicons"
  s.authors     = ["Dan Slocombe"]
  s.email       = 'ds4314@ic.ac.uk'
  s.files       = ["lib/tiledenticon.rb"]
  s.files       = ["lib/tiledenticon.rb", 
                   "lib/face.rb",
                   "lib/tiler.rb"]
  s.homepage    =
    'https://github.com/danslocombe/tiledenticon'
  s.license       = 'MIT'
  s.add_runtime_dependency "chunky_png",
    ["~> 1.3"]
end


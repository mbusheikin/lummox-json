Pod::Spec.new do |s|
  s.name = "lummox-json"
  s.version = "1.0"
  s.summary = "Some json and introspection magic in Objective C."
  s.description = "Contains some wrapping around object introspection (like figuring
  				out what properties of an object are, and of what types. 
  				Plus code to go from Json (foundation objects) to ObjC objects and vice versa."
  s.homepage = "https://github.com/mbusheikin/lummox-json"
  s.license = 'MIT'
  s.author = "Michael Busheikin"
  s.source = { :git => "https://github.com/mbusheikin/lummox-json.git", :tag => "v1.0" }
  s.platform = :ios
  s.source_files = 'LummoxJson/LummoxJson'
end

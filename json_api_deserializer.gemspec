lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "json_api_deserializer/version"

Gem::Specification.new do |spec|
  spec.name          = "json_api_deserializer"
  spec.version       = JsonApiDeserializer::VERSION
  spec.authors       = ["Nicholas Palaniuk"]
  spec.email         = ["npalaniuk+github@gmail.com"]

  spec.summary       = %q{Deserializer for JSON API spec}
  spec.description   = %q{Deserializer for JSON API spec}
  spec.homepage      = "https://github.com/nikkypx/json_api_deserializer"

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rspec"
  spec.add_dependency "case_transform"
  spec.add_dependency "activesupport"
end

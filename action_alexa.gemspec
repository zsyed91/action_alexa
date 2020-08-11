require_relative 'lib/action_alexa/version'

Gem::Specification.new do |spec|
  spec.name          = "action_alexa"
  spec.version       = ActionAlexa::VERSION
  spec.authors       = ["Zshawn Syed"]
  spec.email         = ["zsyed91@gmail.com"]

  spec.summary       = %q{Gem to add Amazon Alexa API callbacks to Rails}
  spec.description   = %q{Gem that helps process Amazon Alexa Intents with Rails}
  spec.homepage      = "https://github.com/zsyed91/action_alexa"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/zsyed91/action_alexa"
  spec.metadata["changelog_uri"] = "https://github.com/zsyed91/action_alexa/blob/master/CHANGE.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end

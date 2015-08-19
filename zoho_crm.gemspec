# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'zoho_crm/version'

Gem::Specification.new do |spec|
  spec.name          = "zoho_crm"
  spec.version       = ZohoCrm::Client::VERSION
  spec.authors       = ["Ciaran Lofts"]
  spec.email         = ["ciaran@wishpond.com"]

  spec.summary       = %q{Light wrapper for the ZohoCRM API allowing users to interact with the Contacts and Leads modules}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com' to prevent pushes to rubygems.org, or delete to allow pushes to any server."
  end

  spec.add_dependency 'httparty'
  spec.add_development_dependency 'bundler', "~> 1.9"
  spec.add_development_dependency 'rake', "~> 10.0"
  spec.add_development_dependency 'rspec'

end

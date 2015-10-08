Gem::Specification.new do |gem|
  gem.name          = 'omniauth-saml-va'
  gem.version       = '0.1'
  gem.summary       = 'A generic VA SAML strategy for OmniAuth.'
  gem.description   = 'A generic VA SAML strategy for OmniAuth.'
  gem.license       = 'MIT'

  gem.authors       = 'Paul Tagliamonte'
  gem.email         = 'paul.tagliamonte@va.gov'
  gem.homepage      = ''

  gem.add_runtime_dependency 'omniauth-saml', '~> 1.4.0'

  gem.files         = Dir['lib/**/*.rb']
  gem.require_paths = ["lib"]
end

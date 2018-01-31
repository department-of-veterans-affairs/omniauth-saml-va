Gem::Specification.new do |gem|
  gem.name          = 'omniauth-saml-va'
  gem.version       = '0.1'
  gem.summary       = 'A generic VA SAML strategy for OmniAuth.'
  gem.description   = 'A generic VA SAML strategy for OmniAuth.'
  gem.license       = 'CC0'  # This work is a work of the US Federal Government,
  #               This work is Public Domain in the USA, and CC0 Internationally

  gem.authors       = 'Paul Tagliamonte'
  gem.email         = 'paul.tagliamonte@va.gov'
  gem.homepage      = ''

  gem.add_runtime_dependency 'omniauth-saml', '~> 1.8'

  gem.files         = Dir['lib/**/*.rb']
  gem.require_paths = ["lib"]
end

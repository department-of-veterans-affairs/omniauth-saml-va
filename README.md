omniauth-saml-va
================

Example usage:

```Ruby
if not ENV.has_key? 'SAML_XML_LOCATION'
  raise 'SAML_XML_LOCATION is not set'
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :samlva, 'CASEFLOW', ENV['SAML_XML_LOCATION'],
    :path_prefix => '/some-prefix/auth',
end
```

omniauth-saml-va
================

Example usage:

```Ruby
if not ENV.has_key? 'SAML_XML_LOCATION'
  raise 'SAML_XML_LOCATION is not set'
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :samlva, 'CASEFLOW', ENV['SAML_PRIVATE_KEY'], ENV['SAML_XML_LOCATION'],
    :path_prefix => '/some-prefix/auth',
end
```

License
=======

[The project is in the public domain](LICENSE.md), and all contributions will also be released in the public domain. By submitting a pull request, you are agreeing to waive all rights to your contribution under the terms of the [CC0 Public Domain Dedication](http://creativecommons.org/publicdomain/zero/1.0/).

This project constitutes an original work of the United States Government.

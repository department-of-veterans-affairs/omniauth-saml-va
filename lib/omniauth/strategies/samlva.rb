require 'omniauth/strategies/saml'

require 'nokogiri'
require 'openssl'
require 'base64'

module OmniAuth
  module Strategies
    class SAMLVA < OmniAuth::Strategies::SAML
      def initialize(app, issuer=nil, private_key=nil, configuration_xml=nil, options={}, &block)
        doc = Nokogiri.XML(File.open(configuration_xml, 'rb'))
        cert = OpenSSL::X509::Certificate.new(Base64.decode64(doc.xpath(
            "//*[local-name()='KeyDescriptor']//*[local-name()='X509Certificate']/text()"
        )[0].text))
        location = doc.xpath("//*[local-name()='SingleSignOnService']/@Location")[0].text

        private_key = File.read(private_key)

        options[:issuer] = issuer
        options[:private_key] = private_key

        options[:idp_sso_target_url] ||= location
        options[:idp_cert] ||= cert.to_pem
        options[:name_identifier_format] ||= "urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress"
        super(app, options, &block)
      end
    end
  end
end

OmniAuth.config.add_camelization 'samlva', 'SAMLVA'

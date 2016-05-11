require 'omniauth/strategies/saml'

require 'nokogiri'
require 'openssl'
require 'base64'

module OmniAuth
  module Strategies
    class SAMLVA < OmniAuth::Strategies::SAML
      def initialize(app, issuer=nil, private_key=nil, certificate=nil, configuration_xml=nil, sign=false, options={}, &block)
        doc = Nokogiri.XML(File.open(configuration_xml, 'rb'))
        cert = OpenSSL::X509::Certificate.new(Base64.decode64(doc.xpath(
            "//*[local-name()='KeyDescriptor']//*[local-name()='X509Certificate']/text()"
        )[0].text))
        location = doc.xpath("//*[local-name()='SingleSignOnService']/@Location")[0].text

        private_key = File.read(private_key)
        certificate = File.read(certificate)

        options[:issuer] = issuer
        options[:private_key] = private_key
        options[:certificate] = certificate

        options[:idp_sso_target_url] ||= location
        options[:idp_cert] ||= cert.to_pem
        options[:name_identifier_format] ||= "urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress"
        options[:security] = {
          :authn_requests_signed    => sign,
          :logout_requests_signed   => sign,
          :logout_responses_signed  => sign,
          :want_assertions_signed   => sign,
          :metadata_signed          => sign,
          :embed_sign               => sign,
          :digest_method            => XMLSecurity::Document::SHA256,
          :signature_method         => XMLSecurity::Document::RSA_SHA256
        }

        super(app, options, &block)
      end

      # def request_phase
      #   redirect("#{options[:idp_sso_target_url]}?SPID=#{options[:issuer]}")
      # end
    end
  end
end

OmniAuth.config.add_camelization 'samlva', 'SAMLVA'

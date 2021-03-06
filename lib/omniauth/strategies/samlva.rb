require 'omniauth/strategies/saml'

require 'nokogiri'
require 'openssl'
require 'base64'

module OmniAuth
  module Strategies
    class SAMLVA < OmniAuth::Strategies::SAML
      attr_accessor :iam_provider

      def initialize(app, issuer=nil, private_key=nil, certificate=nil, configuration_xml=nil, sign=false, options={}, &block)
        doc = Nokogiri.XML(File.open(configuration_xml, 'rb'))
        cert = OpenSSL::X509::Certificate.new(Base64.decode64(doc.xpath(
            "//*[local-name()='KeyDescriptor']//*[local-name()='X509Certificate']/text()"
        )[0].text))
        location = doc.xpath("//*[local-name()='SingleSignOnService']/@Location")[0].text

        private_key = File.read(private_key)
        certificate = File.read(certificate)

        self.iam_provider = options[:va_iam_provider]

        options[:issuer] = issuer
        options[:private_key] = private_key
        options[:certificate] = certificate

        options[:idp_sso_target_url] ||= location
        options[:idp_cert] ||= cert.to_pem
        options[:name_identifier_format] ||= "urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress"
        options[:allowed_clock_drift] ||= 30.seconds

        options[:security] = {
          :authn_requests_signed    => sign,
          :logout_requests_signed   => false,
          :logout_responses_signed  => false,
          :want_assertions_signed   => false,
          :metadata_signed          => false,
          :embed_sign               => false,
          :digest_method            => XMLSecurity::Document::SHA256,
          :signature_method         => XMLSecurity::Document::RSA_SHA256
        }

        super(app, options, &block)
      end

      def request_phase
        return redirect("#{options[:idp_sso_target_url]}?SPID=#{options[:issuer]}") if self.iam_provider == :iam
        super
      end
    end
  end
end

OmniAuth.config.add_camelization 'samlva', 'SAMLVA'

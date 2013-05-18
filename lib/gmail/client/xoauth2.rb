require 'gmail_xoauth'

module Gmail
  module Client
    class XOAuth2 < Base
      attr_reader :access_token

      def initialize(username, access_token)
        @access_token = access_token
        super(username, {:access_token => access_token})
      end

      def login(raise_errors=false)
        @imap and @logged_in = (login = @imap.authenticate('XOAUTH2', username, access_token)) && login.name == 'OK'
      rescue
        raise_errors and raise AuthorizationError, "Couldn't login to given GMail account: #{username}"
      end

      def smtp_settings
        [:smtp, {
           :address => GMAIL_SMTP_HOST,
           :port => GMAIL_SMTP_PORT,
           :domain => mail_domain,
           :user_name => username,
           :password => {:access_token => access_token},
           :authentication => :xoauth,
           :enable_starttls_auto => true
         }]
      end
    end # XOAuth

    register :xoauth2, XOAuth2
  end # Client
end # Gmail

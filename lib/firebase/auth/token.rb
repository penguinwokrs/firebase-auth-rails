module Firebase
  module Auth
    class Token
      attr_reader :token
      attr_reader :payload

      def initialize(payload: {}, token: nil, verify_options: {})
        set_public_key
        @token = token
        @payload = FirebaseIdToken::Signature.verify(token)
        # user not found or decode error
        # raise StandardError, 'decode error' if @payload.nil?
      end

      def entity_for(entity_class)
        if entity_class.respond_to? :from_token_payload
          entity_class.from_token_payload @payload
        else
          # FIXME: error handling
          entity_class.find_by!(uid: @payload['sub'])
        end
      end

      def set_public_key
        # FIXME: cache
        FirebaseIdToken::Certificates.request! unless 60 <= FirebaseIdToken::Certificates.ttl
        nil
      end
    end
  end
end

# frozen_string_literal: true


FirebaseIdToken.configure do |config|
  config.project_ids = ['firebase-id-token']
  config.redis =  Redis.new(host: 'localhost')
end

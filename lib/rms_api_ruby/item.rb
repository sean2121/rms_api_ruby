module RmsApiRuby
  class Item
    autoload :Get, 'rms_api_ruby/item/get'

    class << self
      def get(args)
        call_api Get.new(args)
      end

      private

      def call_api(api)
        Flow.new.
          chain(response: :response) { api.call }.
          on_dam { |error| handle_error(error) }.
          outflow.
          try(:response)
      end

      def handle_error(error)
        raise error
      rescue ServerError, AuthenticationError => e
        RmsApiRuby.configuration.logger.error(e.message)
      end
    end
  end
end

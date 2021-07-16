# coding: utf-8
# frozen_string_literal: true
module Apress::Utils::Extensions::ActionController
  module Rails30Rescue
    extend ActiveSupport::Concern

    included do
      include Rescue
      ActiveSupport.on_load(:action_controller) do
        include RescueHandler
      end
    end

    module Rescue
      extend ActiveSupport::Concern

      module ClassMethods
        ##
        # usage
        # ApplicationController.rescue_responses.update(
        #   'ActionController::Forbidden' => :forbidden
        # )
        def rescue_responses
          @rescue_responses ||= ActionDispatch::ShowExceptions.rescue_responses
        end

        def default_rescue_response
          @default_rescue_response ||= :internal_server_error
        end

        def default_rescue_response=(response)
          @default_rescue_response = response
        end
      end

      module InstanceMethods
        protected

        def local_request?
          request.local?
        end

        def render_all_errors(exception)
          raise exception if local_request?

          status = response_code_for_rescue(exception)
          if self.respond_to?(status)
            self.send(status)
          else
            self.server_error(exception)
          end
        end

        def response_code_for_rescue(exception)
          self.class.rescue_responses[exception.class.name] || self.class.default_rescue_response
        end
      end
    end

    module RescueHandler
      private

      def process_action(*args)
        super
      rescue Exception => exception
        render_all_errors(exception)
      end
    end

  end
end

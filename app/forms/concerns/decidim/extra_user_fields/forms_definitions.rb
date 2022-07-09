# frozen_string_literal: true

require 'active_support/concern'

module Decidim
  module ExtraUserFields
    # Extra user fields definitions for forms
    module FormsDefinitions
      extend ActiveSupport::Concern

      included do
        include ::Decidim::ExtraUserFields::ApplicationHelper

        attribute :area, String
        attribute :age_group, String
        attribute :gender, String

        validates :area, presence: true
        validates :age_group, presence: true
        validates :gender, presence: true
      end

      def map_model(model)
        extended_data = model.extended_data.with_indifferent_access

        self.area = extended_data[:area]
        self.age_group = extended_data[:age_group]
        self.gender = extended_data[:gender]
      end
    end
  end
end

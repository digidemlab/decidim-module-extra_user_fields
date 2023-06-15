# frozen_string_literal: true

require "active_support/concern"

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

        # Block ExtraUserFields Attributes

        # EndBlock

        validates :area, presence: true, if: :area?
        validates :age_group, presence: true, if: :age_group?
        validates :gender, presence: true, inclusion: { in: Decidim::ExtraUserFields::Engine::DEFAULT_GENDER_OPTIONS.map(&:to_s) }, if: :gender?

        # Block ExtraUserFields Validations

        # EndBlock
      end

      def map_model(model)
        extended_data = model.extended_data.with_indifferent_access

        self.area = extended_data[:area]
        self.age_group = extended_data[:age_group]
        self.gender = extended_data[:gender]

        # Block ExtraUserFields MapModel

        # EndBlock
      end

      private

      def area?
        extra_user_fields_enabled && current_organization.activated_extra_field?(:area)
      end

      def age_group?
        extra_user_fields_enabled && current_organization.activated_extra_field?(:age_group)
      end

      def gender?
        extra_user_fields_enabled && current_organization.activated_extra_field?(:gender)
      end

      # Block ExtraUserFields EnableFieldMethod

      # EndBlock

      def extra_user_fields_enabled
        @extra_user_fields_enabled ||= current_organization.extra_user_fields_enabled?
      end
    end
  end
end

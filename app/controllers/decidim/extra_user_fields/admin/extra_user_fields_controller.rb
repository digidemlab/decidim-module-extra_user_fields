# frozen_string_literal: true

module Decidim
  module ExtraUserFields
    module Admin
      # This controller is the abstract class from which all other controllers of
      # this engine inherit.
      class ExtraUserFieldsController < Admin::ApplicationController
        layout "decidim/admin/settings"

        def index
          @form = form(ExtraUserFieldsForm).instance
        end

        def create
          @form = form(ExtraUserFieldsForm).from_params(
            params,
            current_organization: current_organization
          )

          UpdateExtraUserFields.call(@form) do
            on(:ok) do
              flash[:notice] = t(".success")
              render action: "index"
            end

            on(:invalid) do
              flash.now[:alert] = t(".failure")
              render action: "index"
            end
          end
        end

        def export_users
          enforce_permission_to :read, :officialization

          ExportUsers.call(params[:format], current_user) do
            on(:ok) do |export_data|
              send_data export_data.read, type: "text/#{export_data.extension}", filename: export_data.filename("participants")
            end
          end
        end
      end
    end
  end
end

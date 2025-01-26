module Schools
  class DashboardController < ApplicationController
    before_action :require_school

    def index
      # Add logic for the dashboard
    end

    private

    def require_school
      redirect_to root_url(subdomain: nil), allow_other_host: true, alert: 'School not found' unless @current_school
    end
  end
end

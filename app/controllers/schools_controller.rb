class SchoolsController < ApplicationController
  before_action :set_school, only: %i[ edit update ]
  before_action :authenticate_user!, only: %i[ edit update ]
  before_action :only_admin_authorized, only: %i[ edit update ]
  def new
    @school = School.new
  end

  def create
    @school = School.new(school_params)
    if @school.save
      redirect_to root_url(subdomain: @school.subdomain), allow_other_host: true, notice: "School successfully created! Visit your school's dashboard."
    else
      flash.now[:alert] = "Error creating school. Please check your input."
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @school.update(school_params)
        if @school.saved_change_to_subdomain?
          format.html{ redirect_to main_root_url(subdomain: nil), allow_other_host: true, notice: "New subdomain granted!" }
        else
          format.html { redirect_to school_root_path, notice: "School updated sucessfully!" }
        end
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_school
    @school = @current_school
  end

  def school_params
    params.expect(school: [ :name, :subdomain, :phone_number, :email, :box_address, :motto, :logo ])
  end
end

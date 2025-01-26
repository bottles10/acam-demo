class SchoolsController < ApplicationController
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

  private

  def school_params
    params.require(:school).permit(:name, :subdomain)
  end
end

class SubjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_subject, only: %i[show edit update destroy]
  before_action :only_admin_authorized, except: %i[ index show ]

  def index
    @subjects = @current_school.subjects.all
  end

  def show
  end

  def new
    @subject = @current_school.subjects.new
    @teachers = @current_school.users.all_teachers
  end

  def create
    # Use the model's method to handle subject creation and teacher association
    @subject = @current_school.subjects.find_or_create_with_teachers(subject_params)

    respond_to do |format|
      if @subject.persisted?
        format.html { redirect_to @subject, notice: "Subject successfully created!" }
      else
        @teachers = User.all_teachers
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @teachers = @current_school.users.all_teachers
  end

  def update
    respond_to do |format|
      if @subject.update(subject_params)
        format.html { redirect_to @subject, notice: "Subject updated successfully!" }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @subject.destroy!
    respond_to do |format|
      format.html { redirect_to subjects_path, notice: "Subject successfully deleted!" }
      format.json { head :no_content }
    end
  end

  private

  def set_subject
    @subject = @current_school.subjects.find(params.expect(:id))
  end

  def subject_params
    params.expect(subject: [ :subject_name, teacher_ids: [] ])
  end
end

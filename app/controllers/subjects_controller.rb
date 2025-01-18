class SubjectsController < ApplicationController
  before_action :set_subject, only: %i[show edit update destroy]

  def index
    @subjects = Subject.all
  end

  def show; end

  def new
    @subject = Subject.new
    @teachers = User.all_teachers
  end

  def create
    # Use the model's method to handle subject creation and teacher association
    @subject = Subject.find_or_create_with_teachers(subject_params)

    respond_to do |format|
      if @subject.persisted?
        format.html { redirect_to @subject, notice: "Subject successfully created !" }
      else
        @teachers = User.all_teachers
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @teachers = User.all_teachers
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
    @subject = Subject.find(params.expect(:id))
  end

  def subject_params
    params.expect(subject: [ :subject_name, teacher_ids: [] ])
  end
end

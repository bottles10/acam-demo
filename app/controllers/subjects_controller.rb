class SubjectsController < ApplicationController
  before_action :set_subject, only: %i[ show edit update destroy ]
  def index
    @subjects = Subject.all
  end

  def show
  end

  def new
    @subject = Subject.new
    @teachers = User.all_teachers
  end

  def create
    @subject = Subject.new(subject_params)
    respond_to do |format|
      if @subject.save
        update_teachers
        
        format.html {redirect_to @subject, notice: "Subject successfully created!" }
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
        update_teachers
        format.html { redirect_to @subject, notice: "Subject updated successfully!" }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @subject.destroy!
    respond_to do |format|
      format.html { redirect_to subjects_path, notice: "Subject succesfully deleted!" }
      format.json { head :no_content }
    end
  end


  private
  

  def set_subject
    @subject = Subject.find(params.expect(:id))
  end

  def update_teachers
    teacher_ids = params[:subject][:teacher_ids].reject(&:blank?) # Remove blank values
    @subject.teachers = User.teacher.where(id: teacher_ids)
  end

  def subject_params
    params.expect(subject: [ :name, teacher_ids: [] ])
  end
end

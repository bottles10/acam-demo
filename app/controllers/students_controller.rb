class StudentsController < ApplicationController
  before_action :set_student, only: %i[ show edit update destroy ]
	before_action :only_admin_authorized, except: %i[ index show ]

	def index
		if params[:current_basic].present?
			@students = Student.where(current_basic: params[:current_basic])
		else
			@students = Student.all
		end
	end

	def show
	end

	def new
		@student = Student.new
	end

	def create
		@student = Student.new(student_params)

		respond_to do |format|
			if @student.save
				format.html { redirect_to @student, notice: "New student added successfully!" }
			else
				format.html { render :new, status: :unprocessable_entity }
			end
		end
	end

	def edit
	end

	def update
		respond_to do |format|
			if @student.update(student_params)
				format.html { redirect_to @student, notice: "Student updated successfully!" }
			else
				format.html { render :edit, status: :unprocessable_entity }
			end
		end
	end

	def destroy
		@student.destroy!

		respond_to do |format|
			format.html { redirect_to students_path, status: :see_other, notice: "Student deleted successfully!" }
			format.json { head :no_content }
		end
	end


	private

	def set_student
		@student = Student.find(params.expect(:id))
	end

	def student_params
		params.expect(student: [ :first_name, :middle_name, :last_name, :current_basic ])
	end
end

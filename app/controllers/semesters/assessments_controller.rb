module Semesters
  class AssessmentsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_student_and_semester, only: %i[create]
    before_action :set_assessment, only: %i[destroy]

    def create
      @assessment = @semester.assessments.new(assessment_params)
      @assessment.student = @student

      respond_to do |format|
        if @assessment.save
          if @assessment.student.cutoff_percentage[:class_cutoff_percentage].zero? && @assessment.student.cutoff_percentage[:exam_cutoff_percentage].zero?
            format.html { redirect_to students_path, alert: "Student promoted to a class with no grading scale!" }
          else
            format.html { redirect_to student_reports_path(@student, semester_id: @semester.id), notice: "Assessment created successfully!" }
          end
        else
          format.turbo_stream
        end
      end
    end

    def destroy
      @assessment.destroy!

      respond_to do |format|
        format.html { redirect_to student_reports_path(@student, semester_id: @semester.id), notice: "Assessment destroyed successfully!" }
        format.json { head :no_content }
      end
    end

    private
  
    def set_student_and_semester     
      @semester = @current_school.semesters.find(params.expect(:semester_id))
      @student = @current_school.students.find(params.require(:assessment).require(:student_id))
    end

    def set_assessment
      @assessment = Assessment.find(params.expect(:id))
      @semester = @assessment.semester
      @student = @assessment.student
    end
    
  
    def assessment_params
      params.expect(assessment: [ :attendance_present, :attendance_total, :attitude, 
                                  :conduct, :interest, :class_teacher_remarks, :form_master, :next_basic_level ])
    end
  end
end
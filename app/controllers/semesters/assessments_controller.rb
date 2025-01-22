module Semesters
  class AssessmentsController < ApplicationController
    before_action :set_student_and_semester, only: %i[ create ]
  
    def create
      @assessment = @semester.assessments.new(assessment_params)
      @assessment.student = @student

      respond_to do |format|
  
      if @assessment.save
        format.html { redirect_to student_reports_path(@student, semester_id: @semester.id), notice: "Assessment created successfully!" }
      else
        format.turbo_stream    
      end
    end
    end
  
    private
  
    def set_student_and_semester     
      @semester = Semester.find(params.expect(:semester_id))
      @student = Student.find(params.require(:assessment).require(:student_id))
    end
    
  
    def assessment_params
      params.expect(assessment: [ :attendance_present, :attendance_total, :attitude, 
                                  :conduct, :interest, :class_teacher_remarks, :form_master ])
    end
  end
end
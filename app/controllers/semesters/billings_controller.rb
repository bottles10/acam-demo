module Semesters
  class BillingsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_student_and_semester, only: %i[ new create ]
    before_action :set_billing, only: %i[ edit update destroy ]

    def new
      @billing = @student.billings.new
    end

    def create
      @billing = @student.billings.new(billing_params)

      respond_to do |format|
        if @billing.save
          format.html { redirect_to student_reports_path(@student, semester_id: @semester.id), notice: "Billing created successfully!" }
        else
          format.html { render :new, status: :unprocessable_entity }
        end
      end
    end

    def edit
    end

    def update
      respond_to do |format|
        if @billing.update(billing_params)
          format.html { redirect_to student_reports_path(@student, semester_id: @semester.id), notice: "Billing updated successfully!" }
        else
          format.html { render :edit, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      @billing.destroy!

      respond_to do |format|
        format.html { redirect_to student_reports_path(@student, semester_id: @semester.id), notice: "Billing destroyed sucessfully!" }
        format.json { head :no_content }
      end
    end


    private

    def set_student_and_semester
      @semester = @current_school.semesters.find(params.expect(:semester_id))
      student_id = params[:student_id] || params.dig(:billing, :student_id)
      @student = @current_school.students.find(student_id)
    end
    
    def set_billing
      @billing = Billing.find(params.expect(:id))
      @student = @billing.student
      @semester = @billing.semester
    end

    def billing_params
      params.expect(billing: [ :title, :amount, :student_id, :semester_id ])
    end
  end
end
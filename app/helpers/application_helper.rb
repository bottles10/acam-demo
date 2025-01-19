module ApplicationHelper
  def current_term(student)
    year = student.reports&.first&.semester&.year&.year.to_s
    term = student.reports&.first&.semester&.term.to_s
    "#{year} Term #{term}"
  end
end

module ApplicationHelper
  def current_term(student, semester)
    return unless semester.present?

    year = semester.year.year
    term = semester.term
    "#{year} Term #{term}"
  end
end

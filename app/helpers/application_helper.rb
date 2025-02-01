module ApplicationHelper
  def current_term(student, semester)
    return unless semester.present?

    year = semester.year.year
    term = semester.term
    "#{year} Term #{term}"
  end

  def apply_logo(current_school, width)
    return if current_school.nil?
   if current_school.logo.attached?
    image_tag(rails_blob_path(current_school.logo_blob), width: width)
   else
    "ACAMr"
   end
  end

end

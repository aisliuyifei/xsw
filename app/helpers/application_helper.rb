module ApplicationHelper
  def page_title
    @page_title.present? ? @page_title : "591小说网-最热免费的小说网"
  end
end

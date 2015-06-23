module ApplicationHelper
  def page_title
    @page_title.present? ? @page_title : "我就爱看书-最热免费的小说网"
  end
end

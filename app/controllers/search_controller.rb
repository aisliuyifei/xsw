class SearchController < ApplicationController
  def search
    q = params[:q]
    @books = Book.keyword_search(q).paginate(page: params[:page], per_page: 30)
  end
end

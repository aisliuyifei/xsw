json.array!(@books) do |book|
  json.extract! book, :id, :category_id, :author_name, :name, :original_url, :current_status
  json.url book_url(book, format: :json)
end

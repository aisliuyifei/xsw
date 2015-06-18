json.array!(@chapters) do |chapter|
  json.extract! chapter, :id, :book_id, :name, :content
  json.url chapter_url(chapter, format: :json)
end

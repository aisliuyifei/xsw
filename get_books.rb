#!/usr/bin/env ruby

require 'rubygems'
require 'active_record'
require './app/models/cat'
require './app/models/book'
require './app/models/chapter'
require 'nokogiri'
require 'open-uri'
require 'net/http'


db_config = {}
File.open('config/database.yml', 'r') do |f|
  db_config = YAML.load(f.read)['development']
end

ActiveRecord::Base.establish_connection(db_config)


def retryable(options = {}, &block)
  opts = { :tries => 1, :on => Exception, :interval => 0 }.merge(options)
  retry_exception, retries, interval = opts[:on], opts[:tries], opts[:interval]
  begin
    return yield
  rescue retry_exception
    sleep(interval) if interval > 0
    if (retries -= 1) > 0
      puts "retries:#{retries}"
      retry
    else
      puts "retries:#{retries}" "重试超过5次！"
    end
  end
  yield
end

class InitBook

  def self.get_books
    list_url = 'http://xingzhanfengbao.com/daquan.php'

    doc = Nokogiri::HTML(open(list_url))
    lis = doc.css(".novellist ul li")
    lis.each do |li|
      book_name = li.content.split("/").first
      author_name = li.content.split("/").last
      book_href = "http://xingzhanfengbao.com"+li.css("a").first['href']
      book_category_name = li.parent.parent.css("h2").first.content
      book_category_name.gsub!("大全列表","")
      cat = Cat.find_by_name(book_category_name)
      if not cat
        cat = Cat.new 
        cat.name = book_category_name
        puts "创建分类：#{book_category_name}"
        cat.save
      end
      
      book = Book.find_by_name_and_author_name(book_name,author_name)
      if not book      
        book = Book.new
        book.name = book_name
        book.author_name = author_name
        book.original_url = book_href
        puts "创建新书：#{book_name}"
      end
      book.cat_id = cat.id
      book.save
    end
  end
  
  def self.update_books(start=0)
    Book.all.each do |x|
      if x.id>start
        InitBook.update_book(x)
      end
    end
  end
  
  def self.update_book(book)
    url = book.original_url
    doc = Nokogiri::HTML(open(url))
    puts "OPEN URL #{url}"
    img_url = doc.css("#fmimg img").first['src']
    begin
      File.open("public/img/#{book.id}.jpg", 'wb') do |fo|
        fo.write open(img_url).read 
      end
      book.icon_url = "/img/#{book.id}.jpg"
    rescue
      book.icon_url = '/img/0.jpg'
    end
    book.save
    
    as = doc.css(".box_con dl dd a")
    seq = 0
    as.each do |a|
      seq += 1
      chapter = Chapter.find_by_book_id_and_seq(book.id,seq)
      next if chapter 
      href = url + a['href']
      begin
        retryable(:tries => 5, :on =>Exception,:interval => 1) do
          html = Nokogiri::HTML(open(href))
          if html.css(".bookname h1").first
            chapter_name = html.css(".bookname h1").first.content
            chapter_name.gsub!("章节目录 ","")
            chapter = Chapter.find_by_book_id_and_name(book.id,chapter_name)
            if not chapter
              chapter = Chapter.new
              chapter_content = html.css("#content").first.to_s.force_encoding("gbk").encode("UTF-8", :invalid => :replace, :undef => :replace, :replace => "?")
              chapter.name = chapter_name
              chapter.content = chapter_content
              chapter.book_id = book.id
              chapter.seq = seq
              chapter.save
              puts "#{book.id}:#{chapter.seq}"
            end             
          end 
        end
      rescue
        puts "ERROR: #{href}保存失败"
      end
    end
  end
  
  def self.update_books_with_book_ids(from,to,gap,i)
    puts "IN..."
    x= from + i
    while x <= to
      puts "IN... #{x}"
      book = Book.find(x)
      InitBook.update_book(book) if book
      x += gap
    end
  end
end

# InitBook.get_books
puts "START..."
threads = []

from = 68
to = Book.unscoped.last.id
gap = 12
puts "READY..."

(0..gap-1).each do |x|
   array = []
   threads << Thread.new {
      InitBook.update_books_with_book_ids(from,to,gap,x)
   }
end
threads.each {|t| t.join}

class Post
  include Cequel::Record

  key :id, :int
  column :title, :text
  column :body, :text

  timestamps
end

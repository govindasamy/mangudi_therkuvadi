class CreateArticles < ActiveRecord::Migration[5.2]
  def change
    create_table :articles do |t|
      t.string :headline, :keywords, :headline_short, :cover_image, :title_top, :slug
  		t.text :article_body, :article_leader
  		t.boolean :accept_comments, :default => false
      t.boolean :show_comments, :default => false
      t.boolean :approved, :default => false
      t.integer :author_id
      t.timestamps
    end
    add_index :articles, :slug, unique: true
  end
end

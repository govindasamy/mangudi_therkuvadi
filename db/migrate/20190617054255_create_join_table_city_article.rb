class CreateJoinTableCityArticle < ActiveRecord::Migration[5.2]
  def change
    create_join_table :cities, :articles do |t|
      t.index [:city_id, :article_id]
      t.index [:article_id, :city_id]
    end
  end
end

class RenameCategoryIdToCatId < ActiveRecord::Migration
  def change
    rename_column :books,:category_id,:cat_id
  end
end

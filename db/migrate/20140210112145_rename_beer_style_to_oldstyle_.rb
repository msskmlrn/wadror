class RenameBeerStyleToOldstyle < ActiveRecord::Migration
  def change
    rename_column :beers, :style, :oldstyle_
  end
end

class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.string :name
      t.string :date
      t.integer :review_sum
      t.integer :review_count
    end
  end
end

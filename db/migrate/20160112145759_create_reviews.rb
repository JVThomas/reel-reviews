class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.string :content
      t.integer :score
      t.integer :user_id
      t.integer :movie_id
    end
  end
end

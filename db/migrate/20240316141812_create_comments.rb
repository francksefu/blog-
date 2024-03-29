class CreateComments < ActiveRecord::Migration[7.1]
  def change
    create_table :comments do |t|
      t.text :content
      t.string :name
      t.string :email

      t.references :post, foreign_key: true

      t.timestamps
    end
  end
end

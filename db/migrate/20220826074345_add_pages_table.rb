class AddPagesTable < ActiveRecord::Migration[7.0]
  def up
      create_table "pages" do |t|
          t.string :title
          t.text :content
          # This gives us created_at and updated_at
          t.timestamps
      end
  end
  def down
      drop_table "pages"
  end
end

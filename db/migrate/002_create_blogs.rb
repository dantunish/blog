class CreateBlogs < ActiveRecord::Migration[5.0]
    def up
        create_table :blogs do |t|
            t.string :title
            t.string :post
        end
    end

    def down
        drop_table :blogs
    end
end
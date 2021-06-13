class CreateContracts < ActiveRecord::Migration[6.1]
  def change
    create_table :contracts do |t|
      t.string :title
      t.text :terms

      t.timestamps
    end
  end
end

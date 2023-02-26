class CreateBirds < ActiveRecord::Migration[7.0]
  def change
    create_table :birds do |t|
      t.integer :taxon_order
      t.string :ebird_species_code
      t.string :common_name
      t.string :sci_name
      t.string :four_letter_code
      t.string :aba_rarity_code
      t.boolean :appledore, default: false

      t.timestamps
    end
  end
end

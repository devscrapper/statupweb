class MigrateDataSeaAttacksToSea < ActiveRecord::Migration
  def change
    SeaAttack.all.each{|sea_attack|
    if Sea.exists?({:keywords => sea_attack.keywords, :label_advertising => sea_attack.label_advertising})
      sea = Sea.where({:keywords => sea_attack.keywords, :label_advertising => sea_attack.label_advertising})

    else
      sea = Sea.create({:label => sea_attack.website.label,
                 :advertiser => "adwords",
                 :keywords => sea_attack.keywords,
                 :label_advertising => sea_attack.label_advertising})
    end
    sea_attack.sea_id = sea.id
    sea_attack.save(validate: false)
    }

  end
end

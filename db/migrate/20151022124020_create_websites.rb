# type :
# :local : liens du document dont leur host est celui du document
# :global : liens du document dont leur host est un sous-domaine du host du document
# :full : liens du documents qq soit leur host qui ne sont pas LOCAL, ni GLOBAL
#         pour avoir tous les liens il faut specifier [LOCAL, GLOBAL, FULL]
class CreateWebsites < ActiveRecord::Migration
  def change
    create_table :websites do |t|
      t.string :label, null: false
      t.string :profil_id_ga, null: false, default: "none"
      t.string :url_root, null: false
      t.integer :count_page, null: false, default: 0
      t.string :schemes, null: false, default: ["http", "https"]  # serialisation d'un tableau
      t.string :types, null: false, default: ["local", "global", "full"]  # serialisation d'un tableau
      t.string :advertisers, null: false, default: [""]  # serialisation d'un tableau
      t.integer :count_organic, null: false, default: -1 # nombre de mot cle trouve pour ce website
      t.integer :count_referral,null: false, default: -1 # nombrede referral qui pointe sur ce website
      t.timestamps null: false
    end
  end
end



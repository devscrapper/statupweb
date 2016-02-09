class CreateVisits < ActiveRecord::Migration
  def change
    create_table :visits do |t|
      t.references :policy, polymorphic: true, index: true
      t.string :id_visit, null: false
      t.datetime :start_time, null: false
      t.string :landing_url, null: false
      t.string :durations, null: false
      t.string :referrer, null: false # à remplacer par referrer_id
      t.string :advert, null: false
      t.string :state, null: false, default: "created"
      #données à créer dans un table browser
     # t.string :label, null: false
      # t.string :version, null: false
      # t.string :operating_system,null: false
      # t.string :operating_system_version , null: false
      # données à créer dans une table traffic_source
      # t.string :engine_search, null: false        referral, search
      #t.string :keywords, null: false             referral, search
      #t.string :referral_url, null: false         referral
      #t.string :referral_uri_search, null: false  referral

      t.timestamps null: false
    end
  end
end

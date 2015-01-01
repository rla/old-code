class StartupSchema < ActiveRecord::Migration
  def self.up
    create_table :sites do |t|
      t.string  :name
      t.string  :url
      t.string  :last_error
      t.string  :expression
      t.float   :time_taken, :default => 0.0
      t.boolean :last_ok,    :default => true
      t.timestamps
    end
  end
  def self.down
    drop_table :sites
  end
end

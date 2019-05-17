class Pokemon
  
  attr_reader :id, :name, :type, :db 
  attr_accessor :hp
  
  def initialize(id:, name:, type:, db:, hp: nil)
    @id = id
    @name = name
    @type = type
    @db = db
    @hp = hp
  end
  
  def alter_hp(new_hp, db)
    self.hp = new_hp
    sql = <<-SQL
      UPDATE pokemon
      SET hp = ? 
      WHERE pokemon.id = ?
      SQL
    db.prepare(sql).execute(self.hp, self.id)
  end
  
  def self.find(id, db)
    sql = <<-SQL
      SELECT *
      FROM pokemon
      WHERE pokemon.id = ?
      SQL
    db.prepare(sql).execute(id).map{ |x| self.new_from_db(x, db) }[0]
  end
  
  def self.new_from_db(row, db)
    self.new(
      id: row[0], 
      name: row[1], 
      type: row[2],
      hp: row[3],
      db: db
    )
  end
  
  def self.save(name, type, db)
    sql = <<-SQL
      INSERT INTO pokemon(name, p_type)
      VALUES(?, ?)
      SQL
    db.prepare(sql).execute(name, type)
  end
  
end

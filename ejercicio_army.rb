class Army
	attr_accessor :coins, :civilization, :unities, :battles
  DEFAULT_COINS = 1000.freeze

  def initialize(civilization:)
  	@coins = DEFAULT_COINS
  	@civilization = civilization
    @unities = []
    @battles = []
    set_army
  end

  def points
    unities.inject(0){ |sum,unity| sum + unity.punto_fuerza }
  end

  def to_s
    "Nombre: #{@civilization.nombre} Monedas: #{@coins} Unities: #{@unities.count}  Puntos de fuerza: #{self.points} Batallas: #{@battles}"
  end

  def batallar(other_army, battle_name:)
    battle = Batalla.new(battle_name: battle_name, army1: self, army2: other_army)
  end

  private
  def set_army
    civilization.cant_piqueros.times do
      unities << Piquero.new()
    end

    civilization.cant_arqueros.times do
      unities << Arquero.new()
    end

    civilization.cant_caballeros.times do
      unities << Caballero.new()
    end
  end

end

class Civilization
  attr_accessor :cant_piqueros, :cant_arqueros, :cant_caballeros, :nombre

  def initialize(cant_piqueros:, cant_arqueros: ,cant_caballeros:, nombre:)
    @nombre = nombre
    @cant_piqueros = cant_piqueros
    @cant_arqueros = cant_arqueros
    @cant_caballeros = cant_caballeros
  end
end

class Batalla 
  attr_accessor :battle_name,  :army1, :army2

  def initialize(battle_name:, army1:, army2:)
    @battle_name = battle_name
    @army1 = army1
    @army2 = army2
    fight   
  end

  def fight
    if (@army1.points < army2.points)
      win_battle(army2)
    elsif (army1.points > army2.points)
      win_battle(army1)
    else
      tied
    end
  end

  private 
  def tied 
    army1.unities.sort_by!{ |unity| unity.punto_fuerza }.pop(1)
    army1.battles << [name: @battle_name, date: '2019', result: "Tied"]
    army2.unities.sort_by!{ |unity| unity.punto_fuerza }.pop(1)
    army2.battles << [name: @battle_name, date: '2019', result: "Tied"]
  end
  
  def win_battle(winner)
    if winner == army1 
      army1.coins += 100
      army2.unities.sort_by!{ |unity| unity.punto_fuerza }.pop(2)
      army1.battles << [name: @battle_name, date: '2019', result: "Win"]
      army2.battles << [name: @battle_name, date: '2019', result: "Lose"]
    else 
      army2.coins += 100
      army1.unities.sort_by!{ |unity| unity.punto_fuerza }.pop(2)
      army1.battles << [name: @battle_name, date: '2019', result: "Lose"]
      army2.battles << [name: @battle_name, date: '2019', result: "Win"]
    end
  end

end


class Unity
	attr_accessor :punto_fuerza

  def initialize(punto_fuerza: )
  	@punto_fuerza = punto_fuerza
  end

  def entrenar
    raise "Responsabilidad de la subclase"
  end

  def transformar
    raise "Responsabilidad de la subclase"
  end
end


class Piquero < Unity

  def initialize()
  	super(punto_fuerza: 5)
  end
end

class Arquero < Unity

  def initialize()
  	super(punto_fuerza: 10)
  end
end

class Caballero < Unity

  def initialize()
  	super(punto_fuerza: 20)
  end
end


#workplace

china = Civilization.new(cant_piqueros: 2, cant_arqueros: 25,cant_caballeros: 2, nombre: 'china')

Inglesa = Civilization.new(cant_piqueros: 5, cant_arqueros: 21,cant_caballeros: 1, nombre: 'Inglesa')

army1 = Army.new(civilization: Inglesa)
army2 = Army.new(civilization: china)
p army1.to_s
p army2.to_s
army1.batallar(army2, battle_name: "La Caida de las lechuzas")
p army1.to_s
p army2.to_s


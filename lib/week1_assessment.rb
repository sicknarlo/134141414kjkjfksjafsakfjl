# Put your code here to make the tests pass

class Weapon

  attr_reader :name, :damage

  def initialize(name = nil, dmg = nil)
    raise "Must specify weapon type" if name.nil?
    @name = name
    @damage = dmg
  end

end

class BattleBot

  # @@count = 0
  attr_reader :name, :health, :weapon

  def initialize(name)
    @name = name
    @health = 100
    @weapon = nil
    @dead = false
    @enemies = []
    # @@count += 1
  end

  def pick_up(weapon)
    @weapon = weapon if @weapon.nil?
  end

  def drop_weapon
    @weapon = nil
  end

  def attack(target)
    raise "Cannot attack" if weapon.nil?
    raise ArgumentError.new("Target must be battlebot") unless target.is_a?(BattleBot)
    target.take_damage(weapon.damage)
    target.add_enemy(self)
  end

  def take_damage(dmg)
    @health -= dmg
    dead?
    @health
  end

  # def self.count
  #   @@count
  # end

  def dead?
    @dead = true if @health <= 0
    @dead
  end

  def enemies
    @enemies
  end

  def add_enemy(enemy)
    @enemies << enemy unless @enemies.include?(enemy)
  end

end


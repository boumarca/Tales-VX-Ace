#==============================================================================
# ** Physics_Manager
#------------------------------------------------------------------------------
#  This singleton manages physics and updates
#==============================================================================

module PhysicsManager
  #--------------------------------------------------------------------------
  # * Collision Bitmasks
  #--------------------------------------------------------------------------
  FPS = Graphics.frame_rate
  DELTA_TIME = 1.0 / FPS
  ACCUMULATOR_MAX = 0.2
  GRAVITY_SCALE = 80
  GRAVITY = 9.81
  #--------------------------------------------------------------------------
  # * Setup
  #--------------------------------------------------------------------------
  def self.setup
    init_members
  end
  #--------------------------------------------------------------------------
  # * Stop
  #--------------------------------------------------------------------------
  def self.stop
    @active = false
    @rigidbodies = []
    @collisions = []
    @colliders = []
  end
  #--------------------------------------------------------------------------
  # * Initialize Member Variables
  #--------------------------------------------------------------------------
  def self.init_members
    @accumulator = 0
    @last_time = Time.now
    @active = true
    @rigidbodies = []
    @colliders = []
    @collisions = []
    @gravity = Vector2.new(0, GRAVITY * GRAVITY_SCALE)
  end
  #--------------------------------------------------------------------------
  # * Add a Rigid Body
  #--------------------------------------------------------------------------
  def self.add_rigidbody(body)
    return if @rigidbodies.include?(body)
    @rigidbodies.push(body)
  end
  #--------------------------------------------------------------------------
  # * Remove a Rigid Body
  #--------------------------------------------------------------------------
  def self.remove_rigidbody(body)
    return if !@rigidbodies.include?(body)
    @rigidbodies.delete(body)
  end
  #--------------------------------------------------------------------------
  # * Add a collider
  #--------------------------------------------------------------------------
  def self.add_collider(collider)
    return if @colliders.include?(collider)
    @colliders.push(collider)
  end
  #--------------------------------------------------------------------------
  # * Remove a collider
  #--------------------------------------------------------------------------
  def self.remove_collider(collider)
    return if !@colliders.include?(collider)
    @colliders.delete(collider)
  end
  #--------------------------------------------------------------------------
  # * Physics Loop
  #--------------------------------------------------------------------------
  def self.run_physics
    if @active
      current_time = Time.now
      @accumulator += current_time - @last_time
      @last_time = current_time
      @accumulator = [@accumulator, ACCUMULATOR_MAX].min
      while @accumulator > DELTA_TIME
        update_physics
        @accumulator -= DELTA_TIME
      end
      interpolate_transforms(@accumulator / DELTA_TIME)
    end
  end
  #--------------------------------------------------------------------------
  # * Update Physics
  #--------------------------------------------------------------------------
  def self.update_physics
    @rigidbodies.each { |rigidbody|
      update_forces(rigidbody)
    }

    (0...@colliders.size).each { |i|
      ((i + 1)...@colliders.size).each { |j|
        update_collisions(@colliders[i], @colliders[j])
      }
    }

    @rigidbodies.each { |rigidbody|
      update_position(rigidbody)
    }

    @collisions.each { |collision|
      collision.positional_correction
    }

    @collisions.clear
  end
  #--------------------------------------------------------------------------
  # * Update Forces
  #--------------------------------------------------------------------------
  def self.update_forces(rigidbody)
    gravity = rigidbody.use_gravity ? @gravity : Vector2.zero
    rigidbody.velocity += (rigidbody.forces * rigidbody.inverse_mass + gravity) * (DELTA_TIME/2.0)
  end
  #--------------------------------------------------------------------------
  # * Update Collisions
  #--------------------------------------------------------------------------
  def self.update_collisions(collider_a, collider_b)
    return unless colliding_layers(collider_a, collider_b)
    collision = Physics_Collider.collision_detection(collider_a, collider_b)
    if collision && collision.velocity_along_normal <= 0
      @collisions.push(collision)
      collision.on_collision_trigger(collider_a, collider_b)
      collision.resolve
    end
  end
  #--------------------------------------------------------------------------
  # * Update Rigidbody positions
  #--------------------------------------------------------------------------
  def self.update_position(rigidbody)
    rigidbody.position += rigidbody.velocity * DELTA_TIME
    update_forces(rigidbody)
    rigidbody.reset_forces
  end
  #--------------------------------------------------------------------------
  # * Interpolate Transforms
  #--------------------------------------------------------------------------
  def self.interpolate_transforms(ratio)
    @rigidbodies.each { |rigidbody|
      #rigidbody.position = rigidbody.position * ratio + rigidbody.position * (1 - ratio)
      rigidbody.parent.transform.position = rigidbody.position
    }
  end
  #--------------------------------------------------------------------------
  # * Check if colliding layers
  #--------------------------------------------------------------------------
  def self.colliding_layers(collider_a, collider_b)
    return (collider_a.collision_mask & collider_b.layer) != 0
  end
end

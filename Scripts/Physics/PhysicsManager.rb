#==============================================================================
# ** Physics_Manager
#------------------------------------------------------------------------------
#  This singleton manages physics and updates
#==============================================================================

module PhysicsManager
  #--------------------------------------------------------------------------
  # * Constants
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
  # * Get Gravity
  #--------------------------------------------------------------------------
  def self.gravity
    @gravity
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
    @colliders.each { |collider|
      collider.entity.update_velocity
    }

    (0...@colliders.size).each { |i|
      ((i + 1)...@colliders.size).each { |j|
        update_collisions(@colliders[i], @colliders[j])
      }
    }

    @colliders.each { |collider|
      collider.entity.update_position
    }

    @collisions.each { |collision|
      collision.positional_correction
    }

    @collisions.clear
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
  # * Interpolate Transforms
  #--------------------------------------------------------------------------
  def self.interpolate_transforms(ratio)
    @colliders.each { |collider|
      #rigidbody.position = rigidbody.position * ratio + rigidbody.position * (1 - ratio)
      collider.entity.update_parent
    }
  end
  #--------------------------------------------------------------------------
  # * Check if colliding layers
  #--------------------------------------------------------------------------
  def self.colliding_layers(collider_a, collider_b)
    return (collider_a.collision_mask & collider_b.layer) != 0
  end
end

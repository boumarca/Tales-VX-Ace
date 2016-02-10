#==============================================================================
# ** Physics_Manager
#------------------------------------------------------------------------------
#  This singleton manages physics and updates
#==============================================================================

module PhysicsManager
  FPS = 60.0
  DELTA_TIME = 1 / FPS
  ACCUMULATOR_MAX = 0.2
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
  end
  #--------------------------------------------------------------------------
  # * Initialize Member Variables
  #--------------------------------------------------------------------------
  def self.init_members
    @accumulator = 0
    @last_time = Time.now
    @active = true
    @rigidbodies = []
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
    end
  end
  #--------------------------------------------------------------------------
  # * Update Physics
  #--------------------------------------------------------------------------
  def self.update_physics
    @rigidbodies.each { |rigidbody|
      @rigidbodies.each { |other|
        next if rigidbody == other
        collision = Physics_RigidBody.collision_detection(rigidbody, other)
        if collision && collision.velocity_along_normal <= 0
          collision.object_hit = other.parent
          rigidbody.parent.on_collision(collision)
          Physics_RigidBody.resolve_collision(collision)
          Physics_RigidBody.positional_correction(collision)
        end
      }
    }
    @rigidbodies.each { |rigidbody|
      update_position(rigidbody)
      update_transform(rigidbody.transform, rigidbody)
    }
  end
  #--------------------------------------------------------------------------
  # * Update Rigidbody positions
  #--------------------------------------------------------------------------
  def self.update_position(rigidbody)
    delta_acceleration = rigidbody.force * rigidbody.inverse_mass * DELTA_TIME
    rigidbody.position += (rigidbody.velocity + delta_acceleration / 2.0) * DELTA_TIME
    rigidbody.velocity += delta_acceleration
  end
  #--------------------------------------------------------------------------
  # * Update Transforms
  #--------------------------------------------------------------------------
  def self.update_transform(transform, rigidbody)
    transform.x = rigidbody.position.x
    transform.y = rigidbody.position.y
  end
end

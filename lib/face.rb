# Warning, documentation written in mathsspeak
#
class Face
  # Represents a 2-dimensional tile with sides of unit length in 4-dimensional
  # space
  # V is a vector4 representing the position of the faces base vertex
  # Axis1 and axis2 are the two canonical axis that the face is aligned with
  
  def initialize v, axis1, axis2
    @pos = v
    @a_min = min(axis1, axis2)
    @a_max = max(axis1, axis2)
  end

  # One iteration of the system
  # Position is multiplied by translation_matrix
  # Faces are updated based on algorithm encoded here with switch statements
  #
  # There are some cases where the face splits in two, so we return either a new
  # face or nil
  
  def tick translation_matrix
    ret = nil
    @pos = translation_matrix * @pos
    case @a_min
    when 0
      case @a_max
      when 1
        @a_min = 1
        @a_max = 2
      when 2
        @a_min = 1
        @a_max = 3
      when 3
        @a_min = 0
        @a_max = 1

        ret = Face.new(@pos.clone, 1, 3)
        shunt_pos
      end
    when 1
      case @a_max
      when 2
        @a_min = 2
        @a_max = 3
      when 3
        @a_min = 0
        @a_max = 2

        ret = Face.new(@pos.clone, 2, 3)
        shunt_pos
      end
    when 2
        @a_min = 0
        @a_max = 3

        shunt_pos
    end
    return ret
  end

  # There are several cases in tick where we 'shunt' the position of the face by
  # a constant translation
  private def shunt_pos
    a = @pos.to_a
    @pos = Vector[a[0] - 1, a[1], a[2], a[3] + 1]
  end

  # Getters

  def pos
    @pos
  end

  def min_axis
    @a_min
  end

  def max_axis
    @a_max
  end
end

# Return min of a series of values
def min(*values)
 values.min
end

# Return max of a series of values
def max(*values)
 values.max
end

require 'face'

require 'chunky_png'
require 'matrix'

# Warning, documentation written in mathsspeak

# Convert min axis, max axis tuple to an orientation index
# where axis is between 1 and 4
# and min_axis < max_axis
def min_max_to_i min, max
  return max - 1 if min == 0
  return 1 + max if min == 1
  return 5
end

class TilerBuilder
  # Builder class for Tiler

  def initialize filename
    @hue = 345
    @image_width = 256
    @image_height = 256
    @ox = @image_width/2
    @oy = @image_height/2
    @scale = -24
    @ticks = 22
    @filename = filename
    @sat_major = 1
    @sat_minor = 0.8
    @projection_lambda = Complex(1.01891, 0.602565)
    self
  end
  
  def set_scale scale
    @scale = scale
    self
  end

  def set_hue hue
    @hue = hue
    self
  end

  def set_sat_major s
    @sat_major = s
    self
  end

  def set_sat_minor s
    @sat_minor = s
    self
  end

  def set_image_size width, height
    @image_width = width
    @image_height = height
    self
  end

  def set_ticks ticks
    @ticks = ticks
    self
  end

  def set_projection_lambda x, y
    @projection_lambda = Complex(x, y)
    self
  end

  def build
    t = Tiler.new(@image_width, @image_height, @scale, @hue, @sat_major, 
                  @sat_minor, @projection_lambda)
    t.tile(@ticks, @filename)
  end
end


class Tiler

  # The matrix that we multiply against the position of every face on tick
  @@translation_matrix = 
    Matrix[[0, 0, 0, -1],
           [1, 0, 0,  0],
           [0, 1, 0,  0],
           [0, 0, 1,  1]]

  def initialize image_width, image_height, scale, hue, sat_major, sat_minor, projection_lambda
    
    # We colour based on face orientation index, 
    # 0 and 1 being white
    # 2 and 4 based on hue
    # 3 and 5 based on the compliment of hue

    @h1 = hue
    @h2 = (hue + 360/2) % 360
    
    @colors = [
      ChunkyPNG::Color.from_hsv(0, 0, 1),
      ChunkyPNG::Color.from_hsv(0, 0.0, 1),
      ChunkyPNG::Color.from_hsv(@h1, sat_major, 0.9),
      ChunkyPNG::Color.from_hsv(@h2, sat_major, 0.9),
      ChunkyPNG::Color.from_hsv(@h1, sat_minor, 0.6),
      ChunkyPNG::Color.from_hsv(@h2, sat_minor, 0.6)
    ]

    @image_width = image_width
    @image_height = image_height

    # (ox,oy) describes the centre of the image
    @ox = @image_width/2
    @oy = @image_height/2

    # Scale is the length in pixels of the unit distance when rendered
    @scale = scale

    # Construct the projection of 4 dimensional space onto the output image
    # (cononical_x[i],cononical_y[i]) describes the projection of e_i
    @canonical_x = []
    @canonical_y = []
    for i in 0..3 do
      c = projection_lambda ** i
      @canonical_x << c.real
      @canonical_y << c.imaginary
    end

    # Add an initial face to the list of faces
    @all_faces = [Face.new(Vector[0, 0, 0, 0], 2, 3)]

  end

  # Convert a positional vector 4 to image space
  def to_image_space p, origin_x, origin_y
    {x: (origin_x - @scale * (p[0] * @canonical_x[0] + p[1] * @canonical_x[1] + 
                 p[2] * @canonical_x[2] + p[3] * @canonical_x[3])),
     y: (origin_y + @scale * (p[0] * @canonical_y[0] + p[1] * @canonical_y[1] + 
                 p[2] * @canonical_y[2] + p[3] * @canonical_y[3]))};
  end

  def tile ticks, filename
	
    # Iterate all faces ticks times
    for i in 1 .. ticks
      new_list = []
      @all_faces.each do |face|
        new_list << face
        ret = face.tick @@translation_matrix
        new_list << ret unless ret.nil?
      end
      @all_faces = new_list
    end

    # (global_xo, global_yo) is a translation of the entire rendered surface
    # we do this to centre on a region that is actually tiled
    
    @global_xo = 0
    @global_yo = 0

    # For now we focus on the average position of all faces
    @all_faces.each do |face|
      p = to_image_space(face.pos.to_a, @ox, @oy)
      @global_xo += (@ox - p[:x])/@all_faces.length
      @global_yo += (@oy - p[:y])/@all_faces.length
    end

    # Draw
    puts "Tiledenticon: Drawing image"
    
    # Create a new, blank image
    image = ChunkyPNG::Image.new @image_width, @image_height, @colors[5]

    draw_x = @global_xo + @ox
    draw_y = @global_yo + @oy

    @all_faces.each_with_index do |face, i|
      print "Tiledenticon: Face #{i}\r"

      # Generate the points to a from each face for rendering

      p1 = to_image_space  face.pos.to_a, draw_x, draw_y

      p2_m = face.pos.to_a
      p2_m[face.min_axis] += 1
      p2 = to_image_space p2_m, draw_x, draw_y

      p3_m = face.pos.to_a
      p3_m[face.max_axis] += 1
      p3 = to_image_space p3_m, draw_x, draw_y

      p4_m = face.pos.to_a
      p4_m[face.min_axis] += 1
      p4_m[face.max_axis] += 1
      p4 = to_image_space p4_m, draw_x, draw_y

      points = ChunkyPNG::Vector.new([p1, p2, p4, p3])

      # Pick colour based on colour scheme in @colors array and the direcion the
      # face is orientated
      color = @colors[min_max_to_i face.min_axis, face.max_axis]

      image.polygon(points, ChunkyPNG::Color::TRANSPARENT, color) 
    end

    puts "\nTiledenticon: Saving image to #{filename}"
    image.save(filename, :interlace => false)
  end
  
end

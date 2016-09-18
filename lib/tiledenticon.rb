require 'tiler.rb'

class Tiledenticon
  # Wrapper for the classes defined in this library
  
  def initialize out_folder
    @out_folder = out_folder
  end

  def create str
    # Create a new md5 hasher and feed in the input string
    md5 = Digest::MD5.new
    md5 << str
    hash = md5.hexdigest
    hr = Hashrander.new hash

    fromHashrander "#{@out_folder}/#{str}.png", hr
  end

  # Create a series of parameters from an Hashrander
  private
  def fromHashrander filename, hr
      hue = hr.get_rand 3, 360
      s1 = 0.5 + (hr.get_rand 2, 0.5)
      s2 = 0.5 + (hr.get_rand 2, 0.5 * s1)

      p_x = 0.5 + (hr.get_rand 2, 1.15)
      p_y = 0.5 + (hr.get_rand 2, 1.15)

      TilerBuilder.new(filename).set_hue(hue).set_sat_major(s1).set_sat_minor(s2).set_projection_lambda(p_x, p_y).build
  end
end

class Hashrander

  # Generate random numbers of arbitrary size from a hash
  
  def initialize hash
    @hash_i = 0
    @hash = hash
  end

  def get_rand sample_size, max
    i1 = @hash_i % @hash.length

    hash_str = @hash[i1, sample_size]

    # Check if wrap over length
    rem = i1 + sample_size - @hash.length
    if rem > 0
      hash_str << @hash[0, rem]
    end

    @hash_i += sample_size

    max * hash_str.hex/(16**sample_size)
  end
end

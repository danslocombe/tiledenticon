require 'tiler.rb'

class Tiledenticon
  def initialize out_folder
    @out_folder = out_folder
  end
  def create input
    md5 = Digest::MD5.new
    md5 << input
    hash = md5.hexdigest

    fromMD5 "#{@out_folder}/#{input}.png", hash
  end

  private
  def fromMD5 filename, hash
      r = Hashrander.new(hash)
      hue = r.get_rand 3, 360
      s1 = 0.5 + (r.get_rand 2, 0.5)
      s2 = 0.5 + (r.get_rand 2, 0.5 * s1)

      p_x = 0.5 + (r.get_rand 2, 1.15)
      p_y = 0.5 + (r.get_rand 2, 1.15)

      TilerBuilder.new(filename).set_hue(hue).set_sat_major(s1).set_sat_minor(s2).set_projection_lambda(p_x, p_y).build
  end
end

class Hashrander
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
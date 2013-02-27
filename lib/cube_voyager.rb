require "cube_voyager/version"

module CubeVoyager
  def self.read_csv_matrix(filename)
    IO.readlines(filename).drop(1).map { |line|
      line.split(',').drop(1).map(&:to_f)
    }
  end
end

require 'test/unit'
require 'cube_voyager'

class CubeVoyagerMatrixTest < Test::Unit::TestCase
  def setup
    @sample_data_dir = File.join(File.dirname(__FILE__), 'sample_data')
  end

  def test_read_csv
    mat = CubeVoyager::read_csv_matrix(File.join(@sample_data_dir, 'small_matrix.csv'))
    assert_kind_of(Array, mat)
    assert_equal(5, mat.size)
    assert_kind_of(Array, mat.first)
    assert_equal([7557.04,2260.7,1783.07,1338.51,2325.63], mat.first)
  end

  def test_matrix_open
    assert_nothing_raised {
      handle = CubeVoyager::open_matrix_reader(File.join(@sample_data_dir, 'small_matrix.MAT'))
      CubeVoyager::close_matrix_reader(handle)
    }
  end

  def test_matrix_read
    assert_nothing_raised {
      handle = CubeVoyager::open_matrix_reader(File.join(@sample_data_dir, 'small_matrix.MAT'))
      mat = CubeVoyager::read_matrix(handle, 0)
      assert_kind_of(Array, mat)
      assert_equal(5, mat.size)
      assert_kind_of(Array, mat.first)
      assert_equal(5, mat.first.size)
      CubeVoyager::close_matrix_reader(handle)
    }
  end

end
require "cube_voyager/version"
require 'ffi'

module CubeVoyager
  extend FFI::Library
  ffi_lib 'd:/bdk/source/cube_voyager/lib/VoyagerFileAccess.dll'
  # void* MatReaderOpen(const char *filename, char *errMsg, int errBufLen);
  attach_function :MatReaderOpen,        [ :string, :pointer, :int ],       :pointer
  attach_function :MatReaderGetNumMats,  [ :pointer ],                      :int
  attach_function :MatReaderGetNumZones, [ :pointer ],                      :int
  attach_function :MatReaderClose,       [ :pointer ],                      :void
  attach_function :MatReaderGetRow,      [ :pointer, :int, :int, :pointer], :int
  #attach_function :MatReaderGetMatrixNames, [ :pointer, (Pointer state, String[] names) ], :int
  #attach_function :MatReaderGetRow(Pointer state, int MatNumber, int RowNumber, double[] buffer), :int

  def self.read_csv_matrix(filename)
    IO.readlines(filename).drop(1).map { |line|
      line.split(',').drop(1).map(&:to_f)
    }
  end

  def self.open_matrix_reader(filename)
    err_buffer = FFI::MemoryPointer.from_string("-" * 512)
    handle = MatReaderOpen(filename, err_buffer, 255)
    error_string = err_buffer.read_string.inspect
    raise "Error: Couldn't open #{filename}, because [#{error_string}]"  if handle.null?
    handle
  end

  def self.close_matrix_reader(handle)
    MatReaderClose(handle)
  end

  def self.read_matrix(handle, matrix_number)
    num_zones = MatReaderGetNumZones(handle)
    1..num_zones.map { |i|
      buffer = FFI::MemoryPointer.new(:double, num_zones)
      read = MatReaderGetRow(handle, matrix_number, i, buffer)
      p read
      p buffer.inspect
      buffer.get_array_of_double(0, num_zones)
    }
  end
end



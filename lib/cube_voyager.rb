require 'rubygems'
require 'cube_voyager/version'
require 'ffi'

class FFI::Pointer
  def read_array_of_strings(size)
    return (0..(size-1)).map { |i| 
      str_pointer = self + i * FFI::Type::POINTER.size 
      str_pointer.read_pointer.read_string 
    }
  end
end

module CubeVoyager
  extend FFI::Library
  ffi_lib 'd:/bdk/source/cube_voyager/lib/VoyagerFileAccess.dll'
  #          void* MatReaderOpen(const char *filename, char *errMsg, int errBufLen);
  attach_function :MatReaderOpen,        [ :string, :pointer, :int ],       :pointer

  attach_function :MatReaderGetNumMats,  [ :pointer ],                      :int
  attach_function :MatReaderGetNumZones, [ :pointer ],                      :int
  attach_function :MatReaderClose,       [ :pointer ],                      :void
  attach_function :MatReaderGetRow,      [ :pointer, :int, :int, :pointer], :int
  attach_function :MatReaderGetMatrixNames, [ :pointer, :pointer], :int

  def self.read_csv_matrix(filename)
    IO.readlines(filename).drop(1).map { |line|
      line.split(',').drop(1).map(&:to_f)
    }
  end

  def self.open_matrix_reader(filename)
    err_buffer = FFI::MemoryPointer.from_string('-' * 512)
    # filename.gsub('/', '\\')
    handle = MatReaderOpen(filename, err_buffer, 512)
    error_string = err_buffer.read_string.inspect
    raise "Error: Couldn't open #{filename}, because [#{error_string}]"  if handle.null?
    handle
  end

  def self.close_matrix_reader(handle)
    MatReaderClose(handle)
  end

  def self.get_number_of_matrices(handle)
    return MatReaderGetNumMats(handle)
  end

  def self.get_number_of_zones(handle)
    return MatReaderGetNumZones(handle)
  end

  def self.read_matrix(handle, matrix_number)
    num_zones = MatReaderGetNumZones(handle)
    (1..num_zones).map { |i|
      buffer = FFI::MemoryPointer.new(:double, num_zones)
      read = MatReaderGetRow(handle, matrix_number, i, buffer)
      buffer.get_array_of_double(0, num_zones)
    }
  end

  def self.read_names(handle)
    num_matrices = get_number_of_matrices(handle)
    buffer       = FFI::MemoryPointer.new(:string, num_matrices)
    MatReaderGetMatrixNames(handle, buffer)
    return buffer.read_array_of_strings(num_matrices)
  end
end



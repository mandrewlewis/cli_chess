# frozen_string_literal: true

module Conversions
  def to_int_pair(coordinates = @coordinates)
    return coordinates if coordinates.is_a?(Array)

    coordinates = coordinates.downcase
    int_pair = [
      [*'a'..'h'].find_index(coordinates[0]),
      coordinates[1].to_i - 1
    ]
    int_pair.any?(&:nil?) ? nil : int_pair
  end

  def to_coord_sym(int_pair)
    return int_pair.downcase.to_sym if int_pair.is_a?(Symbol) || int_pair.is_a?(String)

    column = [*'a'..'h'][int_pair[0]]
    row = (int_pair[1] + 1).to_s
    return nil if column.nil? || row.nil?
    
    (column + row).to_sym
  end
end

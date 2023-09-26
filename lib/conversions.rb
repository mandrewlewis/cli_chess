# frozen_string_literal: true

# Coverts between symbol and coordinate pair
module Conversions
  def to_int_pair(coordinates = @coordinates)
    return coordinates if coordinates.is_a?(Array)

    int_pair = [[*'a'..'h'].find_index(coordinates.downcase[0]),
                coordinates[1].to_i - 1]
    int_pair.any?(&:nil?) ? nil : int_pair
  end

  def to_coord_sym(int_pair)
    return int_pair.downcase.to_sym if [Symbol, String].include?(int_pair.class)

    column = [*'a'..'h'][int_pair[0]]
    row = (int_pair[1] + 1).to_s
    return nil if column.nil? || row.nil?

    (column + row).to_sym
  end

  def coord_sym_adjacents(coordinates)
    int_pair = to_int_pair(coordinates)
    left = [int_pair[0] - 1, int_pair[1]]
    right = [int_pair[0] + 1, int_pair[1]]
    [to_coord_sym(left), to_coord_sym(right)]
  end
end

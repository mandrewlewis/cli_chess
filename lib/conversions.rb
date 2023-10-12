# frozen_string_literal: true

# Coverts between symbol and coordinate pair
module Conversions
  def to_int_pair(coordinates = @coordinates)
    return coordinates if coordinates.is_a?(Array)

    int_pair = [[*'a'..'h'].find_index(coordinates[0].downcase),
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

  def flip_vector(vector)
    return [vector[0], -vector[1]] if vector.is_a?(Array)

    vector.map { |k, v| k == :condition ? [k, v] : [k, [v[0], -v[1]]] }.to_h
  end

  def minimize_vector(vector)
    [
      vector[0].zero? ? 0 : vector[0] / (vector[0]).abs,
      vector[1].zero? ? 0 : vector[1] / (vector[1]).abs
    ]
  end

  def trim_vector_by_one(vector)
    mini = minimize_vector(vector)
    [
      vector[0] - mini[0],
      vector[1] - mini[1]
    ]
  end

  def trim_vector_to_target(vector, target)
    until vector == minimize_vector(vector)
      return vector if apply_vector(vector) == to_int_pair(target)

      vector = trim_vector_by_one(vector)
    end
    vector
  end

  def valid_vectors_only(vectors, target)
    valid_vectors = []
    vectors.select { |hash| condition_met?(hash, target) }.each do |hash|
      hash.each_value { |value| valid_vectors << value if value.is_a?(Array) }
    end
    valid_vectors
  end

  def humanized_class
    self.class.to_s.split('::')[-1].downcase
  end
end

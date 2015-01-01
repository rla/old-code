num_of_digits :: Integer -> Integer
num_of_digits 0 = 0
num_of_digits x = 1 + num_of_digits (x `div` 10)

pair_generator limit = [ (x, y) | x <- [1..limit], y <- [1..limit]]

suitable :: (Integer, Integer) -> Bool
suitable (x, y) = num_of_digits (x ^ y) == y

power :: (Integer, Integer) -> Integer
power (x, y) = x ^ y

solution = length (map power (filter suitable (pair_generator 60)))
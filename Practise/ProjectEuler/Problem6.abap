*Project Euler, Problem 6
FORM sum_squares_square_sum USING max TYPE i.
  DATA sum_of_squares TYPE p VALUE 0.
  DATA square_of_sum TYPE p VALUE 0.
  DATA sum TYPE p VALUE 0.
  DATA square TYPE p VALUE 0.
  DATA number TYPE p VALUE 0.
  DO max TIMES.
    number = sy-index.

    sum = sum + number.

    square = number * number.
    sum_of_squares = sum_of_squares + square.
    ENDDO.
  square_of_sum = sum * sum.
  WRITE / sum_of_squares.
  WRITE / square_of_sum.
  ENDFORM.

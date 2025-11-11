#!/bin/bash

# Check if an argument is provided
if [ -z "$1" ]; then
  echo "Please provide an element as an argument."
  exit 0
fi

ARG="$1"

# Query the database using the correct join
ELEMENT=$(
psql --username=freecodecamp --dbname=periodic_table -t --no-align -c "
SELECT e.atomic_number, e.name, e.symbol, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius
FROM properties p
JOIN elements e ON e.atomic_number = p.atomic_number
JOIN types t ON p.type_id = t.type_id
WHERE e.atomic_number::text = '$ARG'
   OR e.symbol = '$ARG'
   OR e.name = '$ARG';
"
)

# If no result, print the “not found” message
if [ -z "$ELEMENT" ]; then
  echo "I could not find that element in the database."
  exit 0
fi

# Split the output
IFS='|' read ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELTING BOILING <<< "$ELEMENT"

# Print formatted message
echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."

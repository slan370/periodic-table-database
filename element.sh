#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

# argument entry
if [[ -z $1 ]]
then
  # send error message
  echo "Please provide an element as an argument."
else
  # if parameter is a number
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    # find by atomic_ umber
    FIND_ELEMENT=$($PSQL "
      SELECT e.atomic_number, e.name, e.symbol, p.atomic_mass, 
      p.melting_point_celsius, p.boiling_point_celsius, t.type 
      FROM elements AS e LEFT JOIN properties AS p 
      ON e.atomic_number = p.atomic_number 
      LEFT JOIN types AS t 
      ON p.type_id = t.type_id 
      WHERE e.atomic_number = $1 
      ")
  else
    # find by symbol or name
    FIND_ELEMENT=$($PSQL "
      SELECT e.atomic_number, e.name, e.symbol, p.atomic_mass, 
      p.melting_point_celsius, p.boiling_point_celsius, t.type 
      FROM elements AS e LEFT JOIN properties AS p 
      on e.atomic_number = p.atomic_number 
      LEFT JOIN types AS t 
      ON p.type_id = t.type_id 
      WHERE symbol = '$1' OR name = '$1' 
      ")
  fi
  # if not element found
  if [[ -z $FIND_ELEMENT ]]
  then
    # send error message
    echo "I could not find that element in the database."
  else
    # elemento encontrado
    echo "$FIND_ELEMENT" | while read ATOMIC_NUMBER BAR NAME BAR SYMBOL BAR ATOMIC_MASS BAR MELTING_POINT_CELSIUS BAR BOILING_POINT_CELSIUS BAR TYPE
    do
      # Final message
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
    done
  fi
fi

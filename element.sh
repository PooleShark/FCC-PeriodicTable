#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Element not found exit
EXIT() {
  echo "I could not find that element in the database."
}

# Output from number message
NUMBER_OUTPUT() {
ELEMENT=$($PSQL "SELECT e.atomic_number, e.name, e.symbol, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius FROM elements e INNER JOIN properties p USING (atomic_number) INNER JOIN types t USING (type_id) WHERE e.atomic_number=$NUMBER_ARG ORDER BY e.atomic_number")
echo $ELEMENT | while IFS='|' read ATOMIC_NUMBER NAME SYMBOL TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT
  do
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  done
}

# Output from symbol message
SYMBOL_OUTPUT() {
ELEMENT=$($PSQL "SELECT e.atomic_number, e.name, e.symbol, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius FROM elements e INNER JOIN properties p USING (atomic_number) INNER JOIN types t USING (type_id) WHERE e.symbol='$SYMBOL_ARG' ORDER BY e.atomic_number")
echo $ELEMENT | while IFS='|' read ATOMIC_NUMBER NAME SYMBOL TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT
  do
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  done
}

# Output from name message
NAME_OUTPUT() {
ELEMENT=$($PSQL "SELECT e.atomic_number, e.name, e.symbol, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius FROM elements e INNER JOIN properties p USING (atomic_number) INNER JOIN types t USING (type_id) WHERE e.name='$NAME_ARG' ORDER BY e.atomic_number")
echo $ELEMENT | while IFS='|' read ATOMIC_NUMBER NAME SYMBOL TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT
  do
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  done
}

# if arg1 is empty
if [[ -z $1 ]]
then
  # empty argument message
  echo "Please provide an element as an argument."
# if arg1 is a number
elif [[ $1 =~ ^[0-9]+$ ]]
then
  # check database for atomic number
  NUMBER_ARG=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1")
  # exit if empty - else output
  if [[ -z $NUMBER_ARG ]]
  then
    EXIT
  else
    NUMBER_OUTPUT
  fi
# if arg1 is symbol
elif [[ ${#1} -lt 3 ]]
then
  # check database for symbol
  SYMBOL_ARG=$($PSQL "SELECT symbol FROM elements WHERE symbol='$1'")
  # exit if empty - else output
  if [[ -z $SYMBOL_ARG ]]
  then
    EXIT
  else
    SYMBOL_OUTPUT
  fi
# if arg1 is name
elif [[ ${#1} -ge 3 ]]
then
  # check database for name
  NAME_ARG=$($PSQL "SELECT name FROM elements WHERE name='$1'")
  # exit if empty - else output
  if [[ -z $NAME_ARG ]]
  then
    EXIT
  else
    NAME_OUTPUT
  fi
fi

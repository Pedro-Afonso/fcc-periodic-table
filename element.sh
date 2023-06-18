#!/bin/bash
# Periodic Table

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

ECHO_SEARCH_RESULT()
{
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
}

if [[ $1 =~ ^[0-9]+$ ]]
then
  ATOMIC_NUMBER_RESULT=$($PSQL "SELECT atomic_number,symbol,name,atomic_mass,type,melting_point_celsius,boiling_point_celsius FROM properties LEFT JOIN elements USING(atomic_number) LEFT JOIN types USING(type_id) WHERE atomic_number=$1;");

  if [[ -z $ATOMIC_NUMBER_RESULT ]]
  then
    echo "I could not find that element in the database."
  else
    echo "$ATOMIC_NUMBER_RESULT" | while IFS='|' read ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS TYPE MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS
      do
        ECHO_SEARCH_RESULT
      done
  fi
elif [[ $1 =~ ^[A-Za-z]+$ ]]
then
  NAME_RESULT=$($PSQL "SELECT atomic_number,symbol,name,atomic_mass,type,melting_point_celsius,boiling_point_celsius FROM properties LEFT JOIN elements USING(atomic_number) LEFT JOIN types USING(type_id) WHERE name='$1' OR symbol='$1';");
  if [[ -z $NAME_RESULT ]]
  then
    echo "I could not find that element in the database."
  else
    echo "$NAME_RESULT" | while IFS='|' read ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS TYPE MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS
      do
        ECHO_SEARCH_RESULT
      done
  fi
else
  echo "Please provide an element as an argument."
fi

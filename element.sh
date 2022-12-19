#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table --tuples-only -c";


if [[ $1 ]]
then
  INPUT=$1
fi
RUN_RESULT(){
  if [[ -z $INPUT ]]
  then
    echo "Please provide an element as an argument."
  elif [[ -z $ATOMIC_RESULT ]]
  then
    echo "I could not find that element in the database."
  else
    echo "$ATOMIC_RESULT" | while read AN BAR NAME BAR SYM BAR TYP BAR AM BAR MPC BAR BPC;
    do 
      echo "The element with atomic number $AN is $NAME ($SYM). It's a $TYP, with a mass of $AM amu. $NAME has a melting point of $MPC celsius and a boiling point of $BPC celsius."
    done
  fi
}
if [[ $INPUT =~ ^[1-9]+$ ]]
then 
  ATOMIC_RESULT=$($PSQL "SELECT elements.atomic_number,name,symbol,types.type,atomic_mass,melting_point_celsius,boiling_point_celsius FROM types INNER JOIN properties ON types.type_id = properties.type_id INNER JOIN elements ON properties.atomic_number = elements.atomic_number WHERE elements.atomic_number = $INPUT");
  RUN_RESULT
elif [[ $INPUT =~ ^[A-Z]$ ]]
then
  ATOMIC_RESULT=$($PSQL "SELECT elements.atomic_number,name,symbol,types.type,atomic_mass,melting_point_celsius,boiling_point_celsius FROM types INNER JOIN properties ON types.type_id = properties.type_id INNER JOIN elements ON properties.atomic_number = elements.atomic_number WHERE elements.symbol = '$INPUT'");
  RUN_RESULT
elif [[ $INPUT =~ ^[A-Z]+[a-z]$ ]]
then
  ATOMIC_RESULT=$($PSQL "SELECT elements.atomic_number,name,symbol,types.type,atomic_mass,melting_point_celsius,boiling_point_celsius FROM types INNER JOIN properties ON types.type_id = properties.type_id INNER JOIN elements ON properties.atomic_number = elements.atomic_number WHERE elements.symbol = '$INPUT'");
  RUN_RESULT
else
  ATOMIC_RESULT=$($PSQL "SELECT elements.atomic_number,name,symbol,types.type,atomic_mass,melting_point_celsius,boiling_point_celsius FROM types INNER JOIN properties ON types.type_id = properties.type_id INNER JOIN elements ON properties.atomic_number = elements.atomic_number WHERE elements.name = '$INPUT'");
  RUN_RESULT
fi
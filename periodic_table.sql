PSQL="psql -X --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit
fi
if [[ $1 =~ ^[0-9]+$ ]]
then
  QUERY_CONDITION="atomic_number=$1"
else
  QUERY_CONDITION="symbol='$1' OR name='$1'"
fi
ELEMENT_SELECTION=$($PSQL "SELECT elements.atomic_number, name, symbol, types.type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types ON properties.type_id=types.type_id WHERE $QUERY_CONDITION")
if [[ -z $ELEMENT_SELECTION ]]
then
  echo "I could not find that element in the database."
else
  IFS="|"
  echo "$ELEMENT_SELECTION" | while read ATOMIC_NUMBER NAME SYMBOL TYPE ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS
  do
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
  done
fi

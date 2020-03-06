# The "re" tool aims to make "cd" operations more efficient
# when targeting recently used folders in a deep hierarchy.
#
# Usage:
#     . re.sh nb_results [folder_name_pattern]
#
# where "nb_results" is the maximal number of folders to display,
# where "folder_name_pattern" restricts the recent folders to those
#   that contain the pattern in their name (i.e., syntactic substring).
#
# This command displays a list of folder whose contents was recently
# modified, ordered with the most recent first. The user provides a digit
# to make its selection. The 'enter' key validates the first choice.
# The effect is to 'cd' to the selected folder.
#
# Suggested alias (assuming the script is located in the home folder):
#    alias re='. ~/re.sh 8'
#
# Example usage:
#  - re      # then type, e.g., '4'
#  - re      # then type 'enter' to jump to the first folder
#  - re foo  # if only one folder then goes into it
#
# Known issue:
#  - reaching folders with spaces in their name won't work.
#  - hidden folders are excluded, there is currently no option to include them
#  - remote folders could be excluded by default, there are not at the moment
#    (see example below

# Parameters

MAX_NB_RESULTS=$1
SELECT=$2
MAX_DEPTH=8

# Excludes all hidden folder (name beginning with "."), and "."
EXCLUDE="-not -path . -regex '.*/\..*' -prune -o "

# Example additional prunning for folders that are mounted using sshfs, add this to EXCLUDE
#     -path './remotefoldertoexclude*' -prune -o

# Define the regexp to filter on folder names
SELECT_REGEXP=""
if [ ! -z "$SELECT" ]; then
  SELECT_REGEXP="-regex '.*$SELECT[^/]*'"
fi

# Find directories, optionnally filtered by name, ordered by date descendent, with a cap on the nb of results
QUERY="find . -maxdepth $MAX_DEPTH $EXCLUDE -type d $SELECT_REGEXP -print0 | xargs -0 -r stat --format '%Y:%n' | sort -nr | cut -d: -f2- | head -n +$MAX_NB_RESULTS"

SRESULTS=$(eval $QUERY)
mapfile -t RESULTS < <(echo "$SRESULTS")

# Counting the number of results
NB_RESULTS=${#RESULTS[@]}

SERROR="No result from recursive search for folder *$SELECT*."
ANSWERID=-1

# Case of 0 result
if [ $NB_RESULTS -eq 0 ]
then
   echo $SERROR

# Case of single result: select this single folder
elif [ $NB_RESULTS -eq 1 ]
then
   if [ -z ${RESULTS[0]} ]; then
     echo $SERROR
   else
     ANSWERID=0
   fi

# Case of multiple results: offer interactive choice
else

   # Display the choices
   for COUNTER in `seq 1 $NB_RESULTS`;
   do
      ID=$(($COUNTER - 1))
      LABEL=${RESULTS[$ID]}
      echo "$COUNTER: $LABEL"
   done

   # Input the user answer; if more than 10 choices, wait for several characters
   if [ $NB_RESULTS -lt 10 ]; then
      read -p "choice? " -n1 ANSWER
      echo ""
   else
      read -p "choice? " ANSWER
   fi

   # Check the answer is a valid numeric value in the expected range

   if [ -z "$ANSWER" ]; then
      ANSWERID=0
   elif [ "$ANSWER" -eq "$ANSWER" ] 2>/dev/null; then
     if [ $ANSWER -gt 0 -a $ANSWER -le $NB_RESULTS ]; then
       ANSWERID=$(($ANSWER - 1))
     else
       echo "Invalid choice."
     fi
     # else echo "Please provide a number."
   fi

fi

if [ ! "$ANSWERID" -eq -1 ]; then
  pushd "${RESULTS[$ANSWERID]}" > /dev/null
fi

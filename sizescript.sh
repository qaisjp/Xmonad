# grab the size, drop the first column (has foldername)
size=$(du -sx ~ --exclude=Yesterday | cut -f1)

# maxsize of disk in KB
maxSize=3221225.472

percent=$(echo $(printf "(%s/$maxSize)*100" $size) | bc -l)

# update for sizes:         vv
dangerMin=$(  echo "$percent>=99" | bc -l)
highMin=$(  echo "$percent>=95" | bc -l)
normalMin=$(echo "$percent>=90" | bc -l)

if [ $dangerMin == "1" ]; then
	printf "Size: <fc=#FF0000>%.2f</fc>%%" $percent
elif [ $highMin == "1" ]; then
	printf "Size: <fc=#FF8500>%.2f</fc>%%" $percent
elif [ $normalMin == "1" ]; then
	printf "Size: <fc=#CCCC00>%.2f</fc>%%" $percent
else
	printf "Size: <fc=#8CC4FF>%.2f</fc>%%" $percent
fi

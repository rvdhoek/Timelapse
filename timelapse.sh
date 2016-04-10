# Setting up directories
backuppath="/home/map/Downloads"
time_stamp=$(date +%Y-%m-%d)
device=1

    cat<<EOF
    ==============================
    Menu video device
    ------------------------------
    Please enter your choice:

    Option video0 (1)
    Option video1 (2)
    Option video2 (3)
           (Q)uit
    ------------------------------
EOF
    read -n1 -s
    case "$REPLY" in
    "1")  echo "you chose choice video0" 
	device=0 ;;
    "2")  echo "you chose choice video1" 
	device=1 ;;
    "3")  echo "you chose choice video2" 
	device=2 ;;
    "Q")  exit                      ;;
    "q")  echo "case sensitive!!"   ;;
     * )  echo "invalid option"     ;;
   esac

if [ ! -d ${backuppath}/${time_stamp} ]; then
mkdir -p "${backuppath}/${time_stamp}"
echo "Make directory ${backuppath}/${time_stamp}"
fi

i=$(find ${backuppath}/${time_stamp}/screen*.jpg | wc -l)

while true; do
    FILENAME=$(printf ${backuppath}/${time_stamp}/screen%010d.jpg $i)
    echo "Capturing screen at $FILENAME";

#test video if not exist
echo "test video"$device
if [ -c /dev/video$device ]; then 
fswebcam  -S 20 -d /dev/video$device -i 0 --title "Video$device" --top-banner --timestamp "$(date +'%Y-%m-%d %H:%M:%S')" --font /usr/share/fonts/truetype/ttf-dejavu/DejaVuSerif.ttf -r 1920x1080 -v -save $FILENAME
fi

#if [ ! -f $FILENAME ]; then
#    echo "Capturing file not found,fault in capturing device!"
#    echo "Reboot! (CTRL+C = Stop)"
#    sleep 10
#    shutdown -P now
#fi

    let i=i+1;

#delay
echo "Wait: (press key to stop)" 
for counter in {001..20}; do
#press any key to stop
	read -t 1 -n 1
	   if [ $? = 0 ] ; then
	   avconv -y -r 10 -i ${backuppath}/${time_stamp}/screen%010d.jpg -r 10 -vcodec libx264 -q:v 3  -vf crop=1920:1080,scale=iw:ih ${backuppath}/${time_stamp}/tlfullhiqual.mp4;
	   exit ;
   	fi
    sleep 0.5
    printf "\r $counter"
done


done

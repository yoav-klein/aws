
function publish() {
    size=$1
    count=$2
    echo "Publishing $count Size=$size"
    aws cloudwatch put-metric-data --metric-name ServerStats --namespace DataCenter --unit Count \
    --value $count --dimensions Size=$size --storage-resolution=1 
}

while [ -n "a" ]; do
    count=$(( RANDOM % 10000 ))
    publish Large $count
   
    count=$(( RANDOM % 10000 ))
    publish Small $count
  
    sleep 10
done

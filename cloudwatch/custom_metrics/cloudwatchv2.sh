
function publish() {
    location=$1
    server=$2
    count=$3
    echo "Publishing $count Server=$server, Location=$location"
    aws cloudwatch put-metric-data --metric-name ServerStats --namespace DataCenter --unit Count \
    --value $count --dimensions Server=$server,Location=$location --storage-resolution=1 
}

while [ -n "a" ]; do
    count=$(( RANDOM % 10000 ))
    publish Frankfurt Prod $count
   
    count=$(( RANDOM % 10000 ))
    publish Frankfurt Beta $count
   
    count=$(( RANDOM % 10000 ))
    publish Rio Prod $count

    count=$(( RANDOM % 10000 ))   
    publish Rio Beta $count
   
    sleep 10
done


while [ -n "a" ]; do
    count=$(( RANDOM % 10000 ))
    server_types=("Prod" "Beta")
    locations=("Frankfurt" "Rio")
    server=${server_types[(( RANDOM % 2 ))]}
    location=${locations[(( RANDOM % 2 ))]}

    echo "Publishing $count Server=$server, Location=$location"
    aws cloudwatch put-metric-data --metric-name ServerStats --namespace DataCenter --unit Count \
    --value $count --dimensions Server=$server,Location=$location --storage-resolution=1
    
    sleep 10
done

$AccountID="412825246027"

aws iam create-role --assume-role-policy-document file://./trust_policy.json --role-name azureIdPRole 
aws iam create-policy --policy-name azureIdpPolicy --policy-document file://./access_policy.json
aws iam attach-role-policy --policy-arn arn:aws:iam::$($AccountID):policy/azureIdpPolicy --role-name azureIdPRole

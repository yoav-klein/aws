

setup_iam() {
    # create IAM role
    echo "== create policy"
    aws iam create-policy --policy-name OpensearchSnapshotPolicy --policy-document file://policy.json

    current_user=$(aws sts get-caller-identity --query='Arn' --output text)
    echo "== current user: $current_user"
    sed "s@<user-arn>@$current_user@" trust-policy.json.template > trust-policy.json
    
    echo "== create role"
    aws iam create-role --role-name OpensearchSnapshotRole --assume-role-policy-document file://trust-policy.json
    policy_arn=$(aws iam list-policies --query "Policies[?PolicyName=='OpensearchSnapshotPolicy'].Arn" --output text)

    echo "== attach them"
    aws iam attach-role-policy --role-name OpensearchSnapshotRole --policy-arn $policy_arn

    role_arn=$(aws iam list-roles --query='Roles[?RoleName==`OpensearchSnapshotRole`].Arn' --output text)
    data=$(aws sts assume-role --role-arn $role_arn --role-session-name opensearch)

    access_key_id=$(echo $data | jq -r '.Credentials.AccessKeyId')
    secret_access_key=$(echo $data | jq -r '.Credentials.SecretAccessKey')
    session_token=$(echo $data | jq -r '.Credentials.SessionToken')
    

    # replace the values in the Dockerfile
}



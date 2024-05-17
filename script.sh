echo 1
TASK_DEFINITION=$(aws ecs describe-task-definition --task-definition "smallCat" --region "us-east-1")
echo 2
NEW_TASK_DEFINITION=$(echo $TASK_DEFINITION | jq --arg IMAGE "065334477167.dkr.ecr.us-east-1.amazonaws.com/my-smallapp:latest" '.taskDefinition | del(.taskDefinitionArn) | del(.revision) | del(.status) | del(.requiresAttributes) | del(.compatibilities) |  del(.registeredAt)  | del(.registeredBy)')
echo 3
NEW_TASK_INFO=$(aws ecs register-task-definition --region "us-east-1" --cli-input-json "$NEW_TASK_DEFINITION")
echo 4
NEW_REVISION=$(echo $NEW_TASK_INFO | jq '.taskDefinition.revision')
echo 5
aws ecs update-service --cluster my-ecs-cluster --service smallCat --task-definition smallCat:${NEW_REVISION}

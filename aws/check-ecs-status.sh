#!/bin/bash

# Quick ECS status check script

set -e

AWS_REGION=${AWS_REGION:-us-east-1}
CLUSTER_NAME="pm-prod-v2-cluster"
SERVICE_NAME="pm-prod-v2-app"

echo "=== ECS Service Status ==="
aws ecs describe-services \
    --cluster "$CLUSTER_NAME" \
    --services "$SERVICE_NAME" \
    --region $AWS_REGION \
    --query 'services[0].{Status:status,Running:runningCount,Desired:desiredCount,Pending:pendingCount}' \
    --output table

echo ""
echo "=== Recent Service Events ==="
aws ecs describe-services \
    --cluster "$CLUSTER_NAME" \
    --services "$SERVICE_NAME" \
    --region $AWS_REGION \
    --query 'services[0].events[:5]' \
    --output table

echo ""
echo "=== Task Status ==="
TASK_ARNS=$(aws ecs list-tasks \
    --cluster "$CLUSTER_NAME" \
    --service-name "$SERVICE_NAME" \
    --region $AWS_REGION \
    --query 'taskArns' \
    --output text)

if [ -n "$TASK_ARNS" ]; then
    aws ecs describe-tasks \
        --cluster "$CLUSTER_NAME" \
        --tasks $TASK_ARNS \
        --region $AWS_REGION \
        --query 'tasks[*].{TaskId:taskArn,Status:lastStatus,Health:healthStatus,Started:startedAt,StopReason:stoppedReason}' \
        --output table
else
    echo "No tasks found"
fi

echo ""
echo "=== Container Health ==="
if [ -n "$TASK_ARNS" ]; then
    for TASK_ARN in $TASK_ARNS; do
        echo "Task: $TASK_ARN"
        aws ecs describe-tasks \
            --cluster "$CLUSTER_NAME" \
            --tasks "$TASK_ARN" \
            --region $AWS_REGION \
            --query 'tasks[0].containers[*].{Name:name,Status:lastStatus,Health:healthStatus,ExitCode:exitCode}' \
            --output table
        echo ""
    done
fi

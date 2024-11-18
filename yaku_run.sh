#!/bin/bash

## *************************************
## UNCOMMENT for creating a new config
## *************************************
# ## Create config object:
# config_json_response=$(curl -sX 'POST' \
#   "${YAKU_ENV_URL}/namespaces/${NAMESPACE_ID}/configs" \
#   -H 'accept: application/json' \
#   -H "Authorization: Bearer ${YAKU_API_TOKEN}" \
#   -H 'Content-Type: application/json' \
#   -d '{
#   "name": "Yaku jenkins Config",
#   "description": "Config to run in Jenkins job"
# }')

# echo $config_json_response

# CONFIG_ID=$(echo $config_json_response | grep -o '"id":[0-9]*' | sed 's/"id"://')
# echo $CONFIG_ID


## *************************************
## UNCOMMENT for creating a new release
## *************************************
# ## Create release
# release_json_response=$(curl -sX'POST' \
#   "${YAKU_ENV_URL}/namespaces/${NAMESPACE_ID}/releases" \
#   -H 'accept: application/json' \
#   -H "Authorization: Bearer ${YAKU_API_TOKEN}" \
#   -H 'Content-Type: application/json' \
#   -d "{
#   \"name\": \"Release 24-Q4\",
#   \"approvalMode\": \"one\",
#   \"qgConfigId\": ${CONFIG_ID},
#   \"plannedDate\": \"2024-12-25T13:32:07.749Z\"}")
# RELEASE_ID=$(echo $release_json_response | grep -o '"id":[0-9]*' | sed 's/"id"://')
# echo $RELEASE_ID

## *********************************************
## UNCOMMENT for uploading files to yaku config
## *********************************************
## Upload config files:
## response code should be 201
# curl -sX'POST' \
#   "${YAKU_ENV_URL}/namespaces/${NAMESPACE_ID}/configs/${CONFIG_ID}/files" \
#   -H 'accept: */*' \
#   -H "Authorization: Bearer ${YAKU_API_TOKEN}" \
#   -H 'Content-Type: multipart/form-data' \
#   -F 'content=@qg-config.yaml;type=application/x-yaml' \
#   -F 'filename=qg-config.yaml'

# curl -sX'POST' \
#   "${YAKU_ENV_URL}/namespaces/${NAMESPACE_ID}/configs/${CONFIG_ID}/files" \
#   -H 'accept: */*' \
#   -H "Authorization: Bearer ${YAKU_API_TOKEN}" \
#   -H 'Content-Type: multipart/form-data' \
#   -F 'content=@test_single.yaml;type=application/x-yaml' \
#   -F 'filename=test-single.yaml'

# curl -sX'POST' \
#   "${YAKU_ENV_URL}/namespaces/${NAMESPACE_ID}/configs/${CONFIG_ID}/files" \
#   -H 'accept: */*' \
#   -H "Authorization: Bearer ${YAKU_API_TOKEN}" \
#   -H 'Content-Type: multipart/form-data' \
#   -F 'content=@test_single_data.json;type=application/json' \
#   -F 'filename=test_single_data.json'


## start yaku run
run_json_response=$(curl -sX'POST' \
  "${YAKU_ENV_URL}/namespaces/${NAMESPACE_ID}/runs" \
  -H 'accept: application/json' \
  -H "Authorization: Bearer ${YAKU_API_TOKEN}" \
  -H 'Content-Type: application/json' \
  -d "{\"configId\": ${CONFIG_ID}}")

RUN_ID=$(echo $run_json_response | grep -o '"id":[0-9]*' | sed 's/"id"://')

## get run status
status=""
max_attempts=10
attempt=0

# Loop until the status is "finished"
while [ "$status" != '"completed"' ] && [ $attempt -lt $max_attempts ]; do
    ((attempt++))

    run_status_json=$(curl -sX'GET' \
    "${YAKU_ENV_URL}/namespaces/${NAMESPACE_ID}/runs/${RUN_ID}" \
    -H 'accept: application/json' \
    -H "Authorization: Bearer ${YAKU_API_TOKEN}")

    
    status=$(echo "$run_status_json" | grep -o '"status"[[:space:]]*:[[:space:]]*"[a-zA-Z]*"' | sed 's/"status"://')   
    echo "Run status: $status"
    
    sleep 5
done

if [[ "$status" == '"completed"' ]]; then
    echo "Run was completed"
else
    echo "Max attempts reached. Run didn't complete'"
fi

## Get release status
release_status_json=$(curl -sX'GET' \
  "${YAKU_ENV_URL}/namespaces/${NAMESPACE_ID}/releases/${RELEASE_ID}" \
  -H 'accept: application/json' \
  -H "Authorization: Bearer ${YAKU_API_TOKEN}")

release_status=$(echo "$release_status_json" | grep -o '"approvalState"[[:space:]]*:[[:space:]]*"[a-zA-Z]*"' | sed 's/"approvalState"://')
echo "Release status: $release_status"
echo $release_status > .release_status
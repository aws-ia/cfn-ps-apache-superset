#!/bin/bash -ex

## NOTE: paths may differ when running in a managed task. To ensure behavior is consistent between
# managed and local tasks always use these variables for the project and project type path
PROJECT_PATH=${BASE_PATH}/project
PROJECT_TYPE_PATH=${BASE_PATH}/projecttype

# Add execute permission and run publishing script s3_publish.sh
if [ -n "${BASE_PATH}" ]
then
    chmod +x $PROJECT_PATH"/.project_automation/publication/s3_publish.sh"
    $PROJECT_PATH"/.project_automation/publication/s3_publish.sh"
else
  echo "Local build mode (skipping publishing)"
fi
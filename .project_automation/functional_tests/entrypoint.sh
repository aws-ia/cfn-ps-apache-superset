#!/bin/bash -ex

## NOTE: paths may differ when running in a managed task. To ensure behavior is consistent between
# managed and local tasks always use these variables for the project and project type path
PROJECT_PATH=${BASE_PATH}/project
PROJECT_TYPE_PATH=${BASE_PATH}/projecttype

printf '\nFunctional test...\n'

DOCS_BRANCH="html-guide"
## Check if docs/ files are modified?
git fetch
git branch
DIFF_OUTPUT=$(git diff HEAD..origin/main)
## If docs are modified, render updated index.html file and
## create a PR with index.html file.
if echo "${DIFF_OUTPUT}" | grep "^diff --git a/docs/"; then
    printf '\nChanges detected in the /docs files. \n'
    #--- Github pages site generation ---#
    asciidoctor --version
    # Generate guide - filename -> index.html
    asciidoctor --base-dir docs/ --backend=html5 -o ../index.html -w --doctype=book -a toc2 -a production_build docs/boilerplate/index_deployment_guide.adoc
    ## Create PR with index.html file
    CURRENT_BRANCH=$(git branch --show-current)
    git checkout main
    git checkout -b "${DOCS_BRANCH}"
    git add index.html
    git commit -m '(automated) rendered html deployment guide'
    git push --set-upstream origin "${DOCS_BRANCH}"
    gh pr create --title 'Generated deployment guide' --body "_This is an automated PR with rendered html file for the deployment guide. Please review it before merge_"
else
    printf '\nNo changes detected in the /docs files. \n'
fi  

##----------------------------------------------------
## Download taskcat overrides from AWS Secrets Manager
## ---------------------------------------------------
## Create a 'secret' of type plaintext in AWS Secrets Manager
## and add taskcat override file contents to it.
## Provide secret name to 'secret_name' parameter below and
## the AWS region where you secret is stored to 'aws_region'.

# set defaults
secret_name=$(cat .taskcat.yml | yq -r '.project|.name')
secret_name=${secret_name}-override
secret_region="us-east-1"
# If overrides secret exists, retrieve the secret value as a JSON string
set +e
overrides=$(aws secretsmanager get-secret-value --secret-id $secret_name --query SecretString --output text --region $secret_region)
# convert the JSON string to YAML and save it to a file
if [ "$?" -eq 0 ]; then
  echo "$overrides" > .taskcat_overrides.yml
fi
set -e
##----------------------------------------------------

# set taskcat general config
cat << EOF > ~/.taskcat.yml
general:
  s3_regional_buckets: true
EOF

# Run taskcat tests
REGIONS=$(aws ec2 describe-regions --region us-east-1 | yq -r '.Regions|.[]|.RegionName')
CSV_REGIONS=$(echo $REGIONS | tr ' ' ',')
taskcat test run  -r $CSV_REGIONS
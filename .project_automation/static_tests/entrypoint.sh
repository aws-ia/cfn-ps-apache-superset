#!/bin/bash -ex

## NOTE: paths may differ when running in a managed task. To ensure behavior is consistent between
# managed and local tasks always use these variables for the project and project type path
PROJECT_PATH=${BASE_PATH}/project
PROJECT_TYPE_PATH=${BASE_PATH}/projecttype

cd $PROJECT_PATH

# Ignoring the following for migration
# All warnings,
# E1019 - Sub validation - false positive for conditionals,
# E2521 - required properties, E3002 - resource properties - false positive for newer resources than pinned CloudFormation resource spec
# E3005 - DependsOn - false positive for conditionals,
# E9101 - Inclusive language check - false positive for database resources
cfn-lint --ignore-checks W,E1019,E2521,E3002,E3005,E9101 -t templates/**/*.yaml -a ~/qs-cfn-lint-rules/qs_cfn_lint_rules/

#!/bin/bash
set -e
npm install
npm run-script build
WORKSPACE=${1:-dev}

pushd pipeline/terraform
terraform init
# If the workspace does not exist, create it.
if ! terraform workspace select ${WORKSPACE}; then
    terraform workspace new ${WORKSPACE}
fi

terraform plan -out=tf.plan -detailed-exitcode && rc=$? || rc=$?

# rc: 0 -> no changes present, 1 -> error, 2 -> pending changes
if [ $rc -eq 2 ]; then
    terraform apply -input=false tf.plan
elif [ $rc -eq 1 ]; then
    exit 1;
fi

popd

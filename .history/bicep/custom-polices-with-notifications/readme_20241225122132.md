# optional step to view the JSON/ARM template
az bicep build -f ./main.bicep

# required steps - azure authentication
az login
az account list

# required steps - deploy to devtest
az account set -s 'xxxx-xxxx-xxxx-xxxx-xxxx'
az deployment sub create -f ./main.bicep -l westeurope -p ./params-dev.json

# required steps - deploy to nonprod
az account set -s 'xxxx-xxxx-xxxx-xxxx-xxxx'
az deployment sub create -f ./main.bicep -l westeurope -p ./params-nonprod.json

# required steps - deploy to prod
az account set -s 'xxxx-xxxx-xxxx-xxxx-xxxx'
az deployment sub create -f ./main.bicep -l westeurope -p ./params-prod.json

# optional step to trigger a subscription-level policy compliance scan (uses current sub context)
az policy state trigger-scan --no-wait
# optional step to view the JSON/ARM template
az bicep build -f ./main.bicep

# required steps
az login

az ad sp create-for-rbac --name bicep-policies-with-code  --role Contributor --scopes /subscriptions/2ed06bf5-fd72-4e3a-b571-d13d54e819e0 --sdk-auth


az deployment sub create -f ./main.bicep -l westeurope

# optional step to trigger a subscription-level policy compliance scan 
az policy state trigger-scan --no-wait
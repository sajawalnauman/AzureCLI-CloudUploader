#!/bin/bash


export $(xargs < clouduploadercli.env)

# This function uses Service Principal to authenticate with Azure

authenticate_using_service_principal() {

	echo "Authenticating...Please Wait."
	local app_ID=$AZ_APP_ID
	local password=$AZ_PASSWORD
	local tenantID=$AZ_TENANT_ID

# Log in using Service Principal 

az login --service-principal -u "$app_ID" -p "$password" --tenant "$tenantID" > /dev/null 2>&1

# If unable to log in, print error message

if [ $? -ne 0 ]; 
then
	echo "Authentication failed. Try Again."
	exit 1
fi
}

# This function uploads the file to blob storage

blob_storage_upload_file () {
	local storage_account=clouduploaderclisa
	local container_name=clouduploaderclicontainer
	local path=$1
	local blob_name=$(basename "$path")

	
	echo "Uploading File...Please Wait."
	
#  Capture Standard Error in a variable
	
err=$(az storage blob upload --account-name "$storage_account" --container-name "$container_name" --file "$path" --name "$blob_name" --auth-mode login 2>&1 >/dev/null)

# Print Success if no errors found

if [ $? -ne 0 ];
then
	echo "$err"
else
	echo "Upload Successful"
	
	echo -n "Do you want to generate a shareable link? (yes/no): "
	read generate_link 

	if [[ "$generate_link" == "yes" ]]; 
	then
		shareable_link=$(generate_sas_url "$storage_account" "$container_name" "$blob_name")
		echo "Shareble Link: $shareable_link"
	fi

fi
}

# Generate SAS token and return a shareable URL

generate_sas_url() {
    local storage_account=$1
    local container_name=$2
    local blob_name=$3

    local sas_token=$(az storage blob generate-sas \
                      --account-name "$storage_account" \
                      --container-name "$container_name" \
                      --name "$blob_name" \
                      --permissions r \
                      --expiry $(date -u -d "1 day" '+%Y-%m-%dT%H:%MZ') \
		      --auth-mode login \
		      --as-user \
                      --output tsv 2>&1)

    if [ -z "$sas_token" ] || [[ $sas_token == *"ERROR"* ]];
    then
        echo "Failed to generate a shareable link for $blob_name.Error: $sas_token"        
	return 1
    fi

    echo "https://${storage_account}.blob.core.windows.net/${container_name}/${blob_name}?${sas_token}"
}

# Authenticate

authenticate_using_service_principal

# Loop through all the provided files to store them

for file in "$@"; do
    if [ -f "$file" ]; then
        blob_storage_upload_file "$file"
    else
        echo "Error: File $file does not exist or is a directory."
    fi
done







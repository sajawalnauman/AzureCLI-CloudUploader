#!/bin/bash


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
	
err=$(az storage blob upload --account-name "$storage_account" --container-name "container_name" --file "$path" --name "$blob_name" --auth-mode login 2>&1 >/dev/null)

# Print Success if no errors found

if [ $? -ne 0 ];
then
	echo "$err"
else
	echo "Upload Successful"
fi
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







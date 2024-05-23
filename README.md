# AzureCLI-CloudUploader

This script uploads files to Azure Blob Storage using a service principal for authentication. It also allows generating shareable links for the uploaded files.

## Prerequisites

- Azure CLI installed and configured on your machine.
- An Azure account with necessary permissions to access Azure Blob Storage.
- A service principal with the required permissions.
- A `.env` file with the following environment variables:
  - `AZ_APP_ID`: Your Azure service principal app ID.
  - `AZ_PASSWORD`: Your Azure service principal password.
  - `AZ_TENANT_ID`: Your Azure tenant ID.

## Setup

1. **Clone the repository:**

    ```bash
    git clone https://github.com/sajawalnauman/AzureCLI-CloudUploader.git
    cd AzureCLI-CloudUploader
    ```

2. **Create a `.env` file in the root directory of the project and add your environment variables:**

    ```plaintext
    AZ_APP_ID=your_app_id
    AZ_PASSWORD=your_password
    AZ_TENANT_ID=your_tenant_id
    ```

3. **Load environment variables:**

    Before running the script, ensure the environment variables are loaded into your shell session:

    ```bash
    source .env
    ```

## Usage

To upload files to Azure Blob Storage, run the script with the file paths as arguments:

```bash
./uploadfilescript.sh <file_path_1> <file_path_2> ...
```

### Example

```bash
./uploadfilescript.sh file1.txt file2.jpg
```

### Generating Shareable Links

After uploading the files, the script will prompt you to generate a shareable link. Type `yes` to generate a read-only SAS token link.

## Script Functions

- **`authenticate_with_service_principal`**: Authenticates with Azure using the service principal.
- **`blob_file_upload_single`**: Uploads a single file to Azure Blob Storage.
- **`generate_sas_url`**: Generates a read-only SAS token for the blob storage.

## Notes

- Ensure that the Azure CLI is logged in and has the necessary permissions to upload files to your Azure Blob Storage account.
- The script captures and displays error messages if the upload or link generation fails.

## Troubleshooting

- If the script fails to authenticate, verify your service principal credentials in the `.env` file.
- Ensure that the Azure CLI is installed and properly configured on your system.
- Check your network connection and permissions if the file upload fails.

## Contributions
- Contributions are welcome! If you have suggestions for improvement or have identified a bug, feel free to open an issue or submit a pull request.

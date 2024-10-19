Here's an amazing `README.md` for your **Dynamic-Conditional-Loop** in Terraform:

---

# Dynamic Conditional Loop in Terraform

This project demonstrates the use of a dynamic block with conditional logic in Terraform. We are provisioning an Azure Resource Group and a Storage Account, with a conditional loop that allows us to set IP rules dynamically based on the provided input.

## Features

- **Azure Resource Group**: Automatically created based on the variable name.
- **Azure Storage Account**: Provisioned with conditional network rules using dynamic blocks.
- **Dynamic Conditional Logic**: Apply IP restrictions only when a list of allowed IPs is provided.

## Terraform Code

### Resource Group Creation

```hcl
resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.name}"
  location = "West Europe"
}
```

### Storage Account Creation with Dynamic Network Rules

```hcl
resource "azurerm_storage_account" "stg" {
  name                = "stg${var.name}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  account_tier        = "Standard"
  account_replication_type = "LRS"

  dynamic "network_rules" {
    for_each = var.ips_allowed == null ? {} : { k = "1" }
    content {
      default_action = "Deny"
      ip_rules       = var.ips_allowed
    }
  }
}
```

## How It Works

- The `azurerm_resource_group` block creates a resource group using the `var.name` variable.
- The `azurerm_storage_account` block creates a storage account within the resource group.
- The `dynamic "network_rules"` block conditionally applies IP restriction rules based on the variable `var.ips_allowed`. 
  - If no IP addresses are provided, the dynamic block is skipped.
  - If a list of IP addresses is provided, network rules are applied to deny all other traffic and allow only the specified IPs.

## Variables

- `var.name`: The name prefix for the resource group and storage account.
- `var.ips_allowed`: A list of IP addresses allowed to access the storage account. If this is `null`, no network rules will be applied.

## Example Usage

```hcl
variable "name" {
  type = string
}

variable "ips_allowed" {
  type    = list(string)
  default = null
}

module "storage_account" {
  source = "./modules/storage"

  name        = "example"
  ips_allowed = ["10.0.0.1", "10.0.0.2"]
}
```

In this example:
- A resource group named `rg-example` and a storage account named `stgexample` will be created.
- Network rules will be applied to allow only `10.0.0.1` and `10.0.0.2` access to the storage account.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 0.12
- Azure CLI for authentication with your Azure account.

## Getting Started

1. Clone this repository:
    ```sh
    git clone <repository-url>
    ```

2. Change into the project directory:
    ```sh
    cd terraform-dynamic-conditional-loop
    ```

3. Initialize Terraform:
    ```sh
    terraform init
    ```

4. Apply the configuration:
    ```sh
    terraform apply
    ```

## License

This project is licensed under the MIT License.

---

This README provides clear documentation on the dynamic conditional logic in Terraform and is structured to make the example understandable and easy to implement!

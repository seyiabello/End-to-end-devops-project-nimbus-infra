variable "project_name" {
  description = "Base name for all resources"
  type        = string
  default     = "nimbus-rg"
}

variable "location" {
  description = "Azure region to deploy resources (e.g., UK South)"
  type        = string
  default     = "West Europe"
}

variable "tags" {
  description = "Common tags applied to all resources"
  type        = map(string)
  default = {
    environment = "Dev"
    owner       = "nimbus"
  }
}

# ACR
variable "acr_sku" {
  description = "SKU for Azure Container Registry (Basic, Standard, Premium)"
  type        = string
  default     = "Basic"
}

# AKS
variable "aks_node_count" {
  description = "Number of nodes in the default AKS node pool"
  type        = number
  default     = 1
}

variable "aks_vm_size" {
  description = "VM size for AKS nodes"
  type        = string
  default     = "Standard_B2s"
}

# Key Vault
variable "kv_sku" {
  description = "SKU for Azure Key Vault (standard or premium)"
  type        = string
  default     = "standard"
}

# Storage
variable "storage_replication_type" {
  description = "Replication type for the storage account (LRS, GRS, RAGRS)"
  type        = string
  default     = "LRS"
}

variable "subscription_id" {
  description = "Azure Subscription ID used by Terraform"
  type        = string
}

variable "tenant_id" {
  description = "Azure Tenant ID used by Terraform"
  type        = string
}


data "azuread_group" "product_team" {
  display_name = var.product_group_name

  count = var.product_group_name == "" ? 0 : 1
}

locals {
  product_group_object_id = var.product_group_name == "" ? var.product_group_object_id : data.azuread_group.product_team[0].object_id
}

resource "azurerm_key_vault_access_policy" "product_team_access_policy" {
  key_vault_id = azurerm_key_vault.kv.id

  object_id = local.product_group_object_id
  tenant_id = data.azurerm_client_config.current.tenant_id

  key_permissions = [
    "list",
    "update",
    "create",
    "import",
    "delete",
  ]

  certificate_permissions = [
    "list",
    "update",
    "create",
    "import",
    "delete",
    "managecontacts",
    "manageissuers",
    "getissuers",
    "listissuers",
    "setissuers",
    "deleteissuers",
  ]

  secret_permissions = [
    "list",
    "set",
    "delete",
  ]
}

resource_group_name           = "analyticsdatabricks-qa-group"
location                      = "westus2"
environment                   = "qa"
application_name              = "analyticsdatabricks"
workspace_sku = "standard"
no_public_ip                  = true
public_network_access_enabled = true

cluster_policies = {        

  
  
  test-policy-2 = {
    name       = "Test Policy with Permissions"
    definition = <<EOT
      {
        "spark_version": {
          "type": "unlimited",
          "defaultValue": "auto:latest-lts"
        },
        "node_type_id": {
          "type": "fixed",
          "value": "Standard_DS3_v2"
        },
        "num_workers": {
          "type": "fixed",
          "value": 2
        },
        "azure_attributes.availability": {
          "type": "unlimited",
          "defaultValue": "ON_DEMAND_AZURE"
        },
        "azure_attributes.spot_bid_max_price": {
          "type": "fixed",
          "value": -1,
          "hidden": true
        },
        "azure_attributes.first_on_demand": {
          "type": "fixed",
          "value": 1
        },
        "driver_node_type_id": {
          "type": "fixed",
          "value": "Standard_DS3_v2"
        },
        "access_mode": {
          "type": "fixed",
          "value": "SINGLE_USER"
        }
      }
    EOT
    permissions = [
      {
        group_name       = "AAD.TestGroup1"
        permission_level = "CAN_USE"
      },
      {
        group_name       = "AAD.TestGroup2"
        permission_level = "CAN_ATTACH_TO"
      }
    ]
  },
test-policy-1 = {
    name       = "Test Policy with Permissions"
    definition = <<EOT
      {
        "spark_version": {
          "type": "unlimited",
          "defaultValue": "auto:latest-lts"
        },
        "node_type_id": {
          "type": "fixed",
          "value": "Standard_DS3_v2"
        },
        "num_workers": {
          "type": "fixed",
          "value": 2
        },
        "azure_attributes.availability": {
          "type": "unlimited",
          "defaultValue": "ON_DEMAND_AZURE"
        },
        "azure_attributes.spot_bid_max_price": {
          "type": "fixed",
          "value": -1,
          "hidden": true
        },
        "azure_attributes.first_on_demand": {
          "type": "fixed",
          "value": 1
        },
        "driver_node_type_id": {
          "type": "fixed",
          "value": "Standard_DS3_v2"
        },
        "access_mode": {
          "type": "fixed",
          "value": "SINGLE_USER"
        }
      }
    EOT
    permissions = [
      {
        group_name       = "AAD.TestGroup1"
        permission_level = "CAN_USE"
      },
      {
        group_name       = "AAD.TestGroup2"
        permission_level = "CAN_ATTACH_TO"
      }
    ]
  },
test-2 = {
    name       = "Test Cluster Policy"
    definition = <<EOT
      {
        "spark_version": {
          "type": "unlimited",
          "defaultValue": "auto:latest-gpu"
        },
        "node_type_id": {
          "type": "fixed",
          "value": "Standard_NC6"
        },
        "num_workers": {
          "type": "fixed",
          "value": 1
        },
        "azure_attributes.availability": {
          "type": "unlimited",
          "defaultValue": "ON_DEMAND_AZURE"
        },
        "azure_attributes.spot_bid_max_price": {
          "type": "fixed",
          "value": -1,
          "hidden": true
        },
        "azure_attributes.first_on_demand": {
          "type": "fixed",
          "value": 1
        },
        "driver_node_type_id": {
          "type": "fixed",
          "value": "Standard_NC6"
        },
        "access_mode": {
          "type": "fixed",
          "value": "SINGLE_USER"
        }
      }
    EOT
  },
test = {
    name       = "Test Cluster Policy"
    definition = <<EOT
      {
        "spark_version": {
          "type": "unlimited",
          "defaultValue": "auto:latest-gpu"
        },
        "node_type_id": {
          "type": "fixed",
          "value": "Standard_NC6"
        },
        "num_workers": {
          "type": "fixed",
          "value": 1
        },
        "azure_attributes.availability": {
          "type": "unlimited",
          "defaultValue": "ON_DEMAND_AZURE"
        },
        "azure_attributes.spot_bid_max_price": {
          "type": "fixed",
          "value": -1,
          "hidden": true
        },
        "azure_attributes.first_on_demand": {
          "type": "fixed",
          "value": 1
        },
        "driver_node_type_id": {
          "type": "fixed",
          "value": "Standard_NC6"
        },
        "access_mode": {
          "type": "fixed",
          "value": "SINGLE_USER"
        }
      }
    EOT
  },
gpu = {
    name       = "GPU Cluster Policy"
    definition = <<EOT
      {
        "spark_version": {
          "type": "unlimited",
          "defaultValue": "auto:latest-gpu"
        },
        "node_type_id": {
          "type": "fixed",
          "value": "Standard_NC6"
        },
        "num_workers": {
          "type": "fixed",
          "value": 1
        },
        "azure_attributes.availability": {
          "type": "unlimited",
          "defaultValue": "ON_DEMAND_AZURE"
        },
        "azure_attributes.spot_bid_max_price": {
          "type": "fixed",
          "value": -1,
          "hidden": true
        },
        "azure_attributes.first_on_demand": {
          "type": "fixed",
          "value": 1
        },
        "driver_node_type_id": {
          "type": "fixed",
          "value": "Standard_NC6"
        },
        "access_mode": {
          "type": "fixed",
          "value": "SINGLE_USER"
        }
      }
    EOT
  },
small = {
    name       = "Small Cluster Policy"
    definition = <<EOT
      {
        "spark_version" : {
          "type"  : "unlimited",
          "defaultValue" : "auto:latest-lts"
        },
        "azure_attributes.availability": {
          "type": "unlimited",
          "defaultValue": "ON_DEMAND_AZURE"
        },
        "azure_attributes.spot_bid_max_price": {
          "type": "fixed",
          "value": -1,
          "hidden": true
        },
        "azure_attributes.first_on_demand": {
          "type": "fixed",
          "value": 1
        },
        "driver_node_type_id": {
          "type": "fixed",
          "value": "Standard_F4s_v2"
        },
        "node_type_id": {
          "type": "allowlist",
          "values": [
            "Standard_F4s_v2",
            "Standard_DS3_v2",
            "Standard_DS4_v2",
            "Standard_DS5_v2"
          ]
        },
        "autoscale.max_workers" : {
          "type"  : "fixed",
          "value" : 2
        },
        "autoscale.min_workers" : {
          "type"  : "fixed",
          "value" : 1
        },
        "autotermination_minutes" : {
          "type"  : "fixed",
          "value" : 120
        },
        "instance_pool_id" : {
          "type": "forbidden",
          "hidden": true
        },
        "dbus_per_hour": {
          "type": "range",
          "maxValue": 30,
          "minValue": 1,
          "defaultValue": 20
        },
        "access_mode": {
          "type": "fixed",
          "value": "SHARED"
        }
      }
    EOT
  },
  general = {
    name       = "General Cluster Policy"
    definition = <<EOT
      {
        "spark_version" : {
          "type"  : "unlimited",
          "defaultValue" : "auto:latest-lts"
        },
        "node_type_id" : {
          "type"  : "fixed",
          "value" : "Standard_DS4_v2"
        },
        "autoscale.max_workers" : {
          "type"  : "fixed",
          "value" : 8
        },
        "autoscale.min_workers" : {
          "type"  : "fixed",
          "value" : 2
        },
        "autotermination_minutes" : {
          "type"  : "fixed",
          "value" : 120
        },
        "instance_pool_id" : {
          "type": "forbidden",
          "hidden": true
        },
        "azure_attributes.availability": {
          "type": "unlimited",
          "defaultValue": "ON_DEMAND_AZURE"
        },
        "azure_attributes.spot_bid_max_price": {
          "type": "fixed",
          "value": -1,
          "hidden": true
        },
        "driver_node_type_id": {
          "type": "fixed",
          "value": "Standard_DS4_v2"
        },
        "access_mode": {
          "type": "fixed",
          "value": "SHARED"
        }
      }
    EOT
  },
  memory = {
    name       = "Memory Cluster Policy"
    definition = <<EOT
      {
        "spark_version" : {
          "type"  : "unlimited",
          "defaultValue" : "auto:latest-lts"
        },
        "node_type_id" : {
          "type"  : "fixed",
          "value" : "Standard_F4s_v2"
        },
        "num_workers" : {
          "type"  : "fixed",
          "value" : 1
        },
        "autotermination_minutes" : {
          "type"  : "fixed",
          "value" : 120
        },
        "instance_pool_id" : {
          "type": "forbidden",
          "hidden": true
        },
        "azure_attributes.availability": {
          "type": "unlimited",
          "defaultValue": "ON_DEMAND_AZURE"
        },
        "azure_attributes.spot_bid_max_price": {
          "type": "fixed",
          "value": 1,
          "hidden": true
        },
        "driver_node_type_id": {
          "type": "fixed",
          "value": "Standard_E16ds_v4"
        },
        "access_mode": {
          "type": "fixed",
          "value": "SHARED"
        }
      }
    EOT
  }
}

virtual_networks = {
  address_prefixes = ["10.121.82.0/23", "10.114.3.32/28"]
  subnets = {
    databricks_public          = "10.121.82.0/24"
    databricks_private         = "10.121.83.0/24"
    workspace_private_endpoint = "10.114.3.32/28"
  }
}

tags = {
  "ApplicationName" = "analyticsdatabricks"
  "Contact"         = "tak.wong@alaskaair.com"
  "Environment"     = "QA"
  "Initiative"      = "DATAOPS"
  "ProductName"     = "analyticsdatabricks"
  "Team" = "Platform"
  "aag-team"        = "Analytics_OPS"
  "aag-tier"        = "3"
  "repo"            = "https://github.com/Alaska-ITS/databricks-team-workspaces.git"
}

/*
Databricks workspace VNET address spaces
TEST 10.118.130.0/23
  QA 10.121.82.0/23
PROD 10.121.84.0/23

Private endpoint VNET address spaces
TEST 10.113.3.32/28
  QA 10.114.3.32/28
PROD 10.115.3.32/28
*/



workspace_name      = "analyticsdatabricks-test-wu2"
resource_group_name = "analyticsdatabricks-test-group"

# Define the root directories and their respective permissions
root_directories = {
  "/CommercialAnalytics" = {
    permissions = [
      {
        group_name       = "AAD.CommercialAnalytics.AzureAccess"
        permission_level = "CAN_READ"
      },
      {
        group_name       = "AADO.CALakehouseRW.NonProd"
        permission_level = "CAN_READ"
      }
    ]
  },
}
secret_scopes = {
  "CommercialAnalytics" = {
    secret_scope_name     = "CommercialAnalytics"
    key_vault_dns_name    = "https://ancommercial-test-kv.vault.azure.net/"
    key_vault_resource_id = "/subscriptions/711baa27-35f4-4bc1-af7a-ee88b5af8977/resourceGroups/commercialanalytics-test-group/providers/Microsoft.KeyVault/vaults/ancommercial-test-kv"
  }
}
secret_scope_acls = {
  "CommercialAnalytics-AADO.CALakehouseRW.NonProd" = {
    scope_name = "CommercialAnalytics"
    principal  = "AADO.CALakehouseRW.NonProd"
    permission = "READ"
  }
}
databricks_clusters = {
  
  
  
        testing = {
    cluster_name       = "testing"
    spark_version      = "14.3.x.scala3.13"
    node_type_id       = "Standard_DS4_v2"
    auto_termination_minutes = 60
    policy             = "Small Cluster Policy"
    num_workers        = 2
    spark_env_vars     = {}
    runtime_engine = "STANDARD"
    azure_attributes = {
      availability = "SPOT_WITH_FALLBACK_AZURE"
    }
    pypl_libraries = {
      "sqlalchemy" = "2.0.40"
      "typing_extensions"  = "4.5.0"
    }
    spark_confs = {}
    java_library_files = {
      "ojdbc8.jar" = "/Volumes/utility_test/ds_utility/dbr_share/ojdbc8.jar"
    }
    custom_tags       = {
      "cluster-owner-team" = "CommercialAnalytics"
      "lifecycle"          = "Permanent"
      "Cluster-type"       = "Small"
      "owner"              = "Tak Wong"
      "Priority"           = "high"
      "Environment"        = "NON-PROD"
      "Group"              = "AAD.CommercialAnalytics.AzureAccess"
      "aag_team"           = "Analytics_OPS"
      "projectcategory"    = "CommercialAnalytics"
      "project"            = "Analytics"
      "workstream"         = "Analytics_Transformation"
      "workloadtype"       = "DailyLoad"
    }
    permissions = [

    ]
  },
testing = {
    cluster_name       = "testing"
    spark_version      = "14.3.x.scala3.13"
    node_type_id       = "Standard_DS4_v2"
    auto_termination_minutes = 60
    policy             = "Small Cluster Policy"
    num_workers        = 2
    spark_env_vars     = {}
    runtime_engine = "STANDARD"
    azure_attributes = {
      availability = "SPOT_WITH_FALLBACK_AZURE"
    }
    pypl_libraries = {
      "sqlalchemy" = "2.0.40"
      "typing_extensions"  = "4.5.0"
    }
    spark_confs = {}
    java_library_files = {
      "ojdbc8.jar" = "/Volumes/utility_test/ds_utility/dbr_share/ojdbc8.jar"
    }
    custom_tags       = {
      "cluster-owner-team" = "CommercialAnalytics"
      "lifecycle"          = "Permanent"
      "Cluster-type"       = "Small"
      "owner"              = "Tak Wong"
      "Priority"           = "high"
      "Environment"        = "NON-PROD"
      "Group"              = "AAD.CommercialAnalytics.AzureAccess"
      "aag_team"           = "Analytics_OPS"
      "projectcategory"    = "CommercialAnalytics"
      "project"            = "Analytics"
      "workstream"         = "Analytics_Transformation"
      "workloadtype"       = "DailyLoad"
    }
    permissions = [

    ]
  },
testing = {
    cluster_name       = "testing"
    spark_version      = "14.3.x.scala3.13"
    node_type_id       = "Standard_DS4_v2"
    auto_termination_minutes = 60
    policy             = "Small Cluster Policy"
    num_workers        = 2
    spark_env_vars     = {}
    runtime_engine = "STANDARD"
    azure_attributes = {
      availability = "SPOT_WITH_FALLBACK_AZURE"
    }
    pypl_libraries = {
      "sqlalchemy" = "2.0.40"
      "typing_extensions"  = "4.5.0"
    }
    spark_confs = {}
    java_library_files = {
      "ojdbc8.jar" = "/Volumes/utility_test/ds_utility/dbr_share/ojdbc8.jar"
    }
    custom_tags       = {
      "cluster-owner-team" = "CommercialAnalytics"
      "lifecycle"          = "Permanent"
      "Cluster-type"       = "Small"
      "owner"              = "Tak Wong"
      "Priority"           = "high"
      "Environment"        = "NON-PROD"
      "Group"              = "AAD.CommercialAnalytics.AzureAccess"
      "aag_team"           = "Analytics_OPS"
      "projectcategory"    = "CommercialAnalytics"
      "project"            = "Analytics"
      "workstream"         = "Analytics_Transformation"
      "workloadtype"       = "DailyLoad"
    }
    permissions = [

    ]
  },
testing = {
    cluster_name       = "testing"
    spark_version      = "14.3.x.scala3.13"
    node_type_id       = "Standard_DS4_v2"
    auto_termination_minutes = 60
    policy             = "Small Cluster Policy"
    num_workers        = 2
    spark_env_vars     = {}
    runtime_engine = "STANDARD"
    azure_attributes = {
      availability = "SPOT_WITH_FALLBACK_AZURE"
    }
    pypl_libraries = {
      "sqlalchemy" = "2.0.40"
      "typing_extensions"  = "4.5.0"
    }
    spark_confs = {}
    java_library_files = {
      "ojdbc8.jar" = "/Volumes/utility_test/ds_utility/dbr_share/ojdbc8.jar"
    }
    custom_tags       = {
      "cluster-owner-team" = "CommercialAnalytics"
      "lifecycle"          = "Permanent"
      "Cluster-type"       = "Small"
      "owner"              = "Tak Wong"
      "Priority"           = "high"
      "Environment"        = "NON-PROD"
      "Group"              = "AAD.CommercialAnalytics.AzureAccess"
      "aag_team"           = "Analytics_OPS"
      "projectcategory"    = "CommercialAnalytics"
      "project"            = "Analytics"
      "workstream"         = "Analytics_Transformation"
      "workloadtype"       = "DailyLoad"
    }
    permissions = [

    ]
  },
testing = {
    cluster_name       = "CommercialAnalytics-New"
    spark_version      = "14.3.x-scala2.12"
    node_type_id       = "Standard_DS4_v2"
    auto_termination_minutes = 60
    policy             = "General Cluster Policy"
    num_workers        = 2
    spark_env_vars     = {}
    runtime_engine = "STANDARD"
    azure_attributes = {
      availability = "SPOT_WITH_FALLBACK_AZURE"
    }
    pypl_libraries = {
      "sqlalchemy" = "2.0.40"
      "typing_extensions"  = "4.5.0"
    }
    spark_confs = {}
    java_library_files = {
      "ojdbc8.jar" = "/Volumes/utility_test/ds_utility/dbr_share/ojdbc8.jar"
    }
    custom_tags       = {
      "cluster-owner-team" = "CommercialAnalytics"
      "lifecycle"          = "Permanent"
      "Cluster-type"       = "Small"
      "owner"              = "Tak Wong"
      "Priority"           = "high"
      "Environment"        = "NON-PROD"
      "Group"              = "AAD.CommercialAnalytics.AzureAccess"
      "aag_team"           = "Analytics_OPS"
      "projectcategory"    = "CommercialAnalytics"
      "project"            = "Analytics"
      "workstream"         = "Analytics_Transformation"
      "workloadtype"       = "DailyLoad"
    }
    permissions = [
      {
        group_name       = "AAD.CommercialAnalytics.AzureAccess"
        permission_level = "CAN_MANAGE"
      }
    ]
  },
testing = {
    cluster_name       = "testing"
    spark_version      = "14.3.x.scala3.13"
    node_type_id       = "Standard_D12_v2"
    auto_termination_minutes = 60
    policy             = "Small Cluster Policy"
    num_workers        = 2
    spark_env_vars     = {}
    runtime_engine = "STANDARD"
    azure_attributes = {
      availability = "SPOT_WITH_FALLBACK_AZURE"
    }
    pypl_libraries = {
      "sqlalchemy" = "2.0.40"
      "typing_extensions"  = "4.5.0"
    }
    spark_confs = {}
    java_library_files = {
      "ojdbc8.jar" = "/Volumes/utility_test/ds_utility/dbr_share/ojdbc8.jar"
    }
    custom_tags       = {
      "cluster-owner-team" = "CommercialAnalytics"
      "lifecycle"          = "Permanent"
      "Cluster-type"       = "Small"
      "owner"              = "Tak Wong"
      "Priority"           = "high"
      "Environment"        = "NON-PROD"
      "Group"              = "AAD.CommercialAnalytics.AzureAccess"
      "aag_team"           = "Analytics_OPS"
      "projectcategory"    = "CommercialAnalytics"
      "project"            = "Analytics"
      "workstream"         = "Analytics_Transformation"
      "workloadtype"       = "DailyLoad"
    }
    permissions = [

    ]
  },
CommercialAnalytics-2 = {
    cluster_name       = "CommercialAnalytics-New"
    spark_version      = "14.3.x-scala2.12"
    node_type_id       = "Standard_DS4_v2"
    auto_termination_minutes = undefined
    policy             = "General Cluster Policy"
    num_workers        = 2
    spark_env_vars     = {}
    runtime_engine = "STANDARD"
    azure_attributes = {
      availability = "SPOT_WITH_FALLBACK_AZURE"
    }
    pypl_libraries = {
      "sqlalchemy" = "2.0.40"
      "typing_extensions"  = "4.5.0"
    }
    spark_confs = {}
    java_library_files = {
      "ojdbc8.jar" = "/Volumes/utility_test/ds_utility/dbr_share/ojdbc8.jar"
    }
    custom_tags       = {
      "cluster-owner-team" = "CommercialAnalytics"
      "lifecycle"          = "Permanent"
      "Cluster-type"       = "Small"
      "owner"              = "Tak Wong"
      "Priority"           = "high"
      "Environment"        = "NON-PROD"
      "Group"              = "AAD.CommercialAnalytics.AzureAccess"
      "aag_team"           = "Analytics_OPS"
      "projectcategory"    = "CommercialAnalytics"
      "project"            = "Analytics"
      "workstream"         = "Analytics_Transformation"
      "workloadtype"       = "DailyLoad"
    }
    permissions = [
      {
        group_name       = "AAD.CommercialAnalytics.AzureAccess"
        permission_level = "CAN_MANAGE"
      }
    ]
  },
CommercialAnalytics-old = {
    cluster_name       = "CommercialAnalytics-New"
    spark_version      = "14.3.x-scala2.12"
    node_type_id       = "Standard_DS4_v2"
    auto_termination_minutes = undefined
    policy             = "General Cluster Policy"
    num_workers        = 2
    spark_env_vars     = {}
    runtime_engine = "STANDARD"
    azure_attributes = {
      availability = "SPOT_WITH_FALLBACK_AZURE"
    }
    pypl_libraries = {
      "sqlalchemy" = "2.0.40"
      "typing_extensions"  = "4.5.0"
    }
    spark_confs = {}
    java_library_files = {
      "ojdbc8.jar" = "/Volumes/utility_test/ds_utility/dbr_share/ojdbc8.jar"
    }
    custom_tags       = {
      "cluster-owner-team" = "CommercialAnalytics"
      "lifecycle"          = "Permanent"
      "Cluster-type"       = "Small"
      "owner"              = "Tak Wong"
      "Priority"           = "high"
      "Environment"        = "NON-PROD"
      "Group"              = "AAD.CommercialAnalytics.AzureAccess"
      "aag_team"           = "Analytics_OPS"
      "projectcategory"    = "CommercialAnalytics"
      "project"            = "Analytics"
      "workstream"         = "Analytics_Transformation"
      "workloadtype"       = "DailyLoad"
    }
    permissions = [
      {
        group_name       = "AAD.CommercialAnalytics.AzureAccess"
        permission_level = "CAN_MANAGE"
      }
    ]
  },
CommercialAnalytics-New = {
    cluster_name       = "CommercialAnalytics-New"
    spark_version      = "14.3.x-scala2.12"
    node_type_id       = "Standard_DS4_v2"
    auto_termination_minutes = undefined
    policy             = "General Cluster Policy"
    num_workers        = 2
    spark_env_vars     = {}
    runtime_engine = "STANDARD"
    azure_attributes = {
      availability = "SPOT_WITH_FALLBACK_AZURE"
    }
    pypl_libraries = {
      "sqlalchemy" = "2.0.40"
      "typing_extensions"  = "4.5.0"
    }
    spark_confs = {}
    java_library_files = {
      "ojdbc8.jar" = "/Volumes/utility_test/ds_utility/dbr_share/ojdbc8.jar"
    }
    custom_tags       = {
      "cluster-owner-team" = "CommercialAnalytics"
      "lifecycle"          = "Permanent"
      "Cluster-type"       = "Small"
      "owner"              = "Tak Wong"
      "Priority"           = "high"
      "Environment"        = "NON-PROD"
      "Group"              = "AAD.CommercialAnalytics.AzureAccess"
      "aag_team"           = "Analytics_OPS"
      "projectcategory"    = "CommercialAnalytics"
      "project"            = "Analytics"
      "workstream"         = "Analytics_Transformation"
      "workloadtype"       = "DailyLoad"
    }
    permissions = [
      {
        group_name       = "AAD.CommercialAnalytics.AzureAccess"
        permission_level = "CAN_MANAGE"
      }
    ]
  },
"CommercialAnalytics-SM" = {
    is_pinned               = true
    cluster_name            = "CommercialAnalytics-SM"
    spark_version           = "14.3.x-scala2.12"
    node_type_id            = "Standard_F4s_v2"
    autotermination_minutes = 60
    policy                  = "Small Cluster Policy"
    num_workers             = 1
    # autoscale = {
    #   min_workers = 1
    #   max_workers = 2
    # }
    spark_env_vars = {}
    custom_tags = {
      "cluster-owner-team" = "CommercialAnalytics"
      "lifecycle"          = "Permanent"
      "Cluster-type"       = "Small"
      "owner"              = "Tak Wong"
      "Priority"           = "high"
      "Environment"        = "NON-PROD"
      "Group"              = "AAD.CommercialAnalytics.AzureAccess"
      "aag_team"           = "Analytics_OPS"
      "projectcategory"    = "CommercialAnalytics"
      "project"            = "Analytics"
      "workstream"         = "Analytics_Transformation"
      "workloadtype"       = "DailyLoad"
    }
    runtime_engine = "STANDARD"
    azure_attributes = {
      availability = "SPOT_WITH_FALLBACK_AZURE"
    }
    pypl_libraries = {
      "sqlalchemy" = "2.0.40"
      "typing_extensions"  = "4.5.0"
    }
    spark_confs = {
      "credentials"                                            = "{{secrets/CommercialAnalytics/credentials}}"
      "google.cloud.auth.service.account.enable"               = "true"
      "spark.hadoop.fs.gs.auth.service.account.email"          = "yujun-tableau@as-digital-marketing.iam.gserviceaccount.com"
      "spark.hadoop.fs.gs.auth.service.account.private.key"    = "{{secrets/CommercialAnalytics/gcp-private-key}}"
      "spark.hadoop.fs.gs.auth.service.account.private.key.id" = "{{secrets/CommercialAnalytics/gcp-private-key-id}}"
      "spark.hadoop.fs.gs.project.id"                          = "as-digital-marketing"
      "spark.network.timeout"                                  = "720s"
      "spark.sql.execution.arrow.pyspark.enabled"              = "false"
      "spark.sql.streaming.stopTimeout"                        = "720s"

    }
    java_library_files = {
      "ojdbc8.jar" = "/Volumes/utility_test/ds_utility/dbr_share/ojdbc8.jar"
    }
    cluster_permissions = [
      {
        group_name       = "AAD.CommercialAnalytics.AzureAccess"
        permission_level = "CAN_MANAGE"
      },
      {
        group_name       = "AAD.CCC.AzureAccess*"
        permission_level = "CAN_MANAGE"
      }
    ]
  }
  "CommercialAnalytics-General" = {
    is_pinned               = true
    cluster_name            = "CommercialAnalytics-General"
    spark_version           = "14.3.x-scala2.12"
    node_type_id            = "Standard_DS4_v2"
    autotermination_minutes = 60
    policy                  = "General Cluster Policy"
    autoscale = {
      min_workers = 2
      max_workers = 8
    }
    spark_env_vars = {}
    custom_tags = {
      "cluster-owner-team" = "CommercialAnalytics"
      "lifecycle"          = "Permanent"
      "Cluster-type"       = "General"
      "owner"              = "Tak Wong"
      "Priority"           = "high"
      "Environment"        = "NON-PROD"
      "Group"              = "AAD.CommercialAnalytics.AzureAccess"
      "aag_team"           = "Analytics_OPS"
      "projectcategory"    = "CommercialAnalytics"
      "project"            = "Analytics"
      "workstream"         = "Analytics_Transformation"
      "workloadtype"       = "DailyLoad"
    }
    runtime_engine = "PHOTON"
    azure_attributes = {
      availability = "SPOT_WITH_FALLBACK_AZURE"
    }
    pypl_libraries = {
      "openpyxl" = ""
      "pyyaml"  = ""
    }
    spark_confs = {
      "credentials"                                            = "{{secrets/CommercialAnalytics/credentials}}"
      "google.cloud.auth.service.account.enable"               = "true"
      "spark.hadoop.fs.gs.auth.service.account.email"          = "yujun-tableau@as-digital-marketing.iam.gserviceaccount.com"
      "spark.hadoop.fs.gs.auth.service.account.private.key"    = "{{secrets/CommercialAnalytics/gcp-private-key}}"
      "spark.hadoop.fs.gs.auth.service.account.private.key.id" = "{{secrets/CommercialAnalytics/gcp-private-key-id}}"
      "spark.hadoop.fs.gs.project.id"                          = "as-digital-marketing"
      "spark.network.timeout"                                  = "720s"
      "spark.sql.execution.arrow.pyspark.enabled"              = "false"
      "spark.sql.streaming.stopTimeout"                        = "720s"

    }
    java_library_files = {
      "ojdbc8.jar" = "/Volumes/utility_test/ds_utility/dbr_share/ojdbc8.jar"
    }
    cluster_permissions = [
      {
        group_name       = "AAD.CommercialAnalytics.AzureAccess"
        permission_level = "CAN_MANAGE"
      },
      {
        group_name       = "AAD.CCC.AzureAccess*"
        permission_level = "CAN_MANAGE"
      }
    ]
  }
  "CommercialAnalytics-Memory" = {
    num_workers             = 1
    is_pinned               = true
    cluster_name            = "CommercialAnalytics-Memory"
    spark_version           = "14.3.x-scala2.12"
    node_type_id            = "Standard_DS12_v2"
    driver_node_type_id     = "Standard_DS3_v2"
    autotermination_minutes = 60
    policy                  = "Memory Cluster Policy"
    spark_env_vars          = {}
    custom_tags = {
      "cluster-owner-team" = "CommercialAnalytics"
      "lifecycle"          = "Permanent"
      "Cluster-type"       = "Memory"
      "owner"              = "Tak Wong"
      "Priority"           = "high"
      "Environment"        = "NON-PROD"
      "Group"              = "AAD.CommercialAnalytics.AzureAccess"
      "aag_team"           = "Analytics_OPS"
      "projectcategory"    = "CommercialAnalytics"
      "project"            = "Analytics"
      "workstream"         = "Analytics_Transformation"
      "workloadtype"       = "DailyLoad"
    }
    runtime_engine = "STANDARD"
    azure_attributes = {
      availability = "ON_DEMAND_AZURE"
    }
    spark_confs = {
      "credentials"                                            = "{{secrets/CommercialAnalytics/credentials}}"
      "google.cloud.auth.service.account.enable"               = "true"
      "spark.hadoop.fs.gs.auth.service.account.email"          = "yujun-tableau@as-digital-marketing.iam.gserviceaccount.com"
      "spark.hadoop.fs.gs.auth.service.account.private.key"    = "{{secrets/CommercialAnalytics/gcp-private-key}}"
      "spark.hadoop.fs.gs.auth.service.account.private.key.id" = "{{secrets/CommercialAnalytics/gcp-private-key-id}}"
      "spark.hadoop.fs.gs.project.id"                          = "as-digital-marketing"
      "spark.network.timeout"                                  = "720s"
      "spark.sql.execution.arrow.pyspark.enabled"              = "false"
      "spark.sql.streaming.stopTimeout"                        = "720s"

    }
    java_library_files = {
      "ojdbc8.jar" = "/Volumes/utility_test/ds_utility/dbr_share/ojdbc8.jar"
    }
    cluster_permissions = [
      {
        group_name       = "AAD.CommercialAnalytics.AzureAccess"
        permission_level = "CAN_MANAGE"
      },
      {
        group_name       = "AAD.CCC.AzureAccess*"
        permission_level = "CAN_MANAGE"
      }
    ]
  }
}
tags = {
  "ApplicationName" = "analyticsdatabricks"
  "Contact"         = "tak.wong@alaskaair.com"
  "Environment"     = "TEST"
  "Initiative"      = "DATAOPS"
  "ProductName"     = "analyticsdatabricks"
  "Team"            = "Analytics"
  "aag_team"        = "Analytics_OPS"
  "aag-tier"        = "3"
  "projectcategory"    = "CommercialAnalytics"
  "project"            = "Analytics"
  "workstream"         = "Analytics_Transformation"
  "workloadtype"       = "DailyLoad"

}
sql_warehouses = {
  
  
  test-1 = {
    name                      = "Test"
    min_num_clusters          = 1
    max_num_clusters          = 1
    auto_stop_mins            = 20
    cluster_size              = "2X-Small"
    enable_serverless_compute = true
    warehouse_type            = "PRO"
    channel                   = "CHANNEL_NAME_CURRENT"
    custom_tags = {
      "cluster-owner-team" = "DataOps"
      "lifecycle"          = "Permanent"
      "Cluster-type"       = "Small"
      "cluster-owner"      = "Tak Wong"
      "Priority"           = "high"
      "Environment"        = "NON-PROD"
      "Group"              = "AAD.CommercialAnalytics.AzureAccess"
    }
  },
small_analytics_wh = {
    name                      = "small-analytics-warehouse"
    min_num_clusters          = 1
    max_num_clusters          = 3
    auto_stop_mins            = 15
    cluster_size              = "2X-Small"
    enable_serverless_compute = true
    warehouse_type            = "PRO"
    channel                   = "CHANNEL_NAME_CURRENT"
    custom_tags = {
      "cluster-owner-team" = "CommercialAnalytics"
      "lifecycle"          = "Permanent"
      "Cluster-type"       = "Small"
      "cluster-owner"      = "Tak Wong"
      "Priority"           = "high"
      "Environment"        = "NON-PROD"
      "Group"              = "AAD.CommercialAnalytics.AzureAccess"
    }
  },
warehouse = {
    name                      = "Commercial Analytics SQL warehouse"
    min_num_clusters          = 1
    max_num_clusters          = 1
    auto_stop_mins            = 20
    cluster_size              = "2X-Small"
    enable_serverless_compute = true
    warehouse_type            = "PRO"
    channel                   = "CHANNEL_NAME_CURRENT"
    custom_tags = {
      "cluster-owner-team" = "CommercialAnalytics"
      "lifecycle"          = "Permanent"
      "Cluster-type"       = "Small"
      "cluster-owner"      = "Tak Wong"
      "Priority"           = "high"
      "Environment"        = "NON-PROD"
      "Group"              = "AAD.CommercialAnalytics.AzureAccess"
    }
  }

  CA_ha_snowflake = {
    name                      = "CA_ha_snowflake"
    min_num_clusters          = 1
    max_num_clusters          = 1
    auto_stop_mins            = 45
    cluster_size              = "Small"
    enable_serverless_compute = false
    warehouse_type            = "PRO"
    channel                   = "CHANNEL_NAME_CURRENT"
    spot_instance_policy      = "COST_OPTIMIZED"
    custom_tags = {
      "aag-team"           = "CommercialAnalytics"
      "Group"              = "AAD.CommercialAnalytics.AzureAccess"
      "cluster_name"       = "CA_ha_snowflake"
      "cluster-owner"      = "Beth Davis"
      "cluster-owner-team" = "CommercialAnalytics"
      "Cluster-type"       = "Small"
      "lifecycle"          = "Permanent"
      "Priority"           = "high"
      "Environment"        = "NON-PROD"
    }
  }
}

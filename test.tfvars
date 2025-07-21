resource_group_name           = "analyticsdatabricks-qa-group"
location                      = "westus2"
environment                   = "qa"
application_name              = "analyticsdatabricks"
workspace_sku = "standard"
no_public_ip                  = true
public_network_access_enabled = true

cluster_policies = {
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
,
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

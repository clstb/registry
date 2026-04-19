terraform {
  required_version = ">= 1.0"

  required_providers {
    coder = {
      source  = "coder/coder"
      version = ">= 2.12"
    }
  }
}

variable "agent_id" {
  type        = string
  description = "The ID of a Coder agent."
}

data "coder_workspace" "me" {}
data "coder_workspace_owner" "me" {}

variable "order" {
  type        = number
  description = "The order determines the position of app in the UI presentation."
  default     = null
}

variable "group" {
  type        = string
  description = "The name of a group that this app belongs to."
  default     = null
}

variable "icon" {
  type        = string
  description = "The icon to use for the app."
  default     = "/icon/forge.svg"
}

variable "folder" {
  type        = string
  description = "The folder to run Forge in."
  default     = "/home/coder"
}

variable "install_forge" {
  type        = bool
  description = "Whether to install Forge."
  default     = true
}

variable "forge_version" {
  type        = string
  description = "The version of Forge to install."
  default     = "latest"
}

variable "install_agentapi" {
  type        = bool
  description = "Whether to install AgentAPI."
  default     = true
}

variable "agentapi_version" {
  type        = string
  description = "The version of AgentAPI to install."
  default     = "v0.10.0"
}

variable "subdomain" {
  type        = bool
  description = "Whether to use a subdomain for AgentAPI."
  default     = false
}

variable "openai_url" {
  type        = string
  description = "The OpenAI compatible API URL for Forge."
  default     = "https://ai.clstb.sh/v1"
}

variable "api_key" {
  type        = string
  description = "The API key for the OpenAI compatible endpoint."
  default     = "sk-dummy"
  sensitive   = true
}

variable "model_id" {
  type        = string
  description = "The model ID for Forge to use."
  default     = "gemini-3-flash"
}

variable "services_url" {
  type        = string
  description = "The services URL for Forge."
  default     = "https://api.forgecode.dev/"
}

variable "pre_install_script" {
  type        = string
  description = "Custom script to run before installing Forge."
  default     = null
}

variable "post_install_script" {
  type        = string
  description = "Custom script to run after installing Forge."
  default     = null
}

locals {
  app_slug        = "forge"
  install_script  = file("${path.module}/scripts/install.sh")
  start_script    = file("${path.module}/scripts/start.sh")
  module_dir_name = ".forge-module"
  folder          = trimsuffix(var.folder, "/")
}

module "agentapi" {
  source  = "registry.coder.com/coder/agentapi/coder"
  version = "2.0.0"

  agent_id             = var.agent_id
  web_app_slug         = local.app_slug
  web_app_order        = var.order
  web_app_group        = var.group
  web_app_icon         = var.icon
  web_app_display_name = "Forge"
  cli_app_slug         = "${local.app_slug}-cli"
  cli_app_display_name = "Forge CLI"
  module_dir_name      = local.module_dir_name
  install_agentapi     = var.install_agentapi
  agentapi_version     = var.agentapi_version
  agentapi_subdomain   = var.subdomain
  pre_install_script   = var.pre_install_script
  post_install_script  = var.post_install_script
  start_script         = local.start_script
  folder               = local.folder
  install_script       = <<-EOT
    #!/bin/bash
    set -o errexit
    set -o pipefail

    echo -n '${base64encode(local.install_script)}' | base64 -d > /tmp/install.sh
    chmod +x /tmp/install.sh

    ARG_INSTALL='${var.install_forge}' \
    ARG_FORGE_VERSION='${var.forge_version}' \
    ARG_OPENAI_URL='${var.openai_url}' \
    ARG_API_KEY='${var.api_key}' \
    ARG_MODEL_ID='${var.model_id}' \
    ARG_SERVICES_URL='${var.services_url}' \
    /tmp/install.sh
  EOT
}

output "task_app_id" {
  value = module.agentapi.task_app_id
}
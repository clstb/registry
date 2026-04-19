---
display_name: Forge
description: Run the Forge agent in your workspace.
icon: ../../../../.icons/forge.svg
verified: true
tags: [agent, forge, ai, tasks]
---

# Forge

Run the Forge agent in your workspace to generate code and perform tasks. This module integrates with [AgentAPI](https://github.com/coder/agentapi) for task reporting in the Coder UI.

```tf
module "forge" {
  source         = "registry.coder.com/clstb/forge/clstb"
  version        = "1.0.1"
  agent_id       = coder_agent.main.id
  folder         = "/home/coder/project"
}
```

## Prerequisites

- Ensure the workspace has Rust and Cargo installed if `install_forge` is `true`.
- The user can start Forge tasks with `FORGE_TASK_PROMPT` provided as an environment variable.

## Setup

```tf
module "forge" {
  source         = "registry.coder.com/clstb/forge/clstb"
  version        = "1.0.1"
  agent_id       = coder_agent.main.id
  folder         = "/home/coder/project"
}
```

By default, the module will download and install the latest version of Forge using `cargo install forgecode`.

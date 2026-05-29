#!/bin/bash
export GITLAB_PERSONAL_ACCESS_TOKEN="${GITLAB_PERSONAL_ACCESS_TOKEN:-$(cat ~/.gitlab-deployer-token 2>/dev/null)}"
export GITLAB_API_URL="https://gitlab.inframax.tech"
exec npx -y @zereight/mcp-gitlab

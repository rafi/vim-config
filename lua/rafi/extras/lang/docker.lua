-- Docker: Dockerfile and compose language servers, hadolint linter
-- Tree-sitter parser installed on demand by arborist.
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/lang/docker.lua
require('rafi.util.lang').add({
	servers = { dockerls = true, docker_compose_language_service = true },
	tools = { 'hadolint' },
	linters_by_ft = { dockerfile = { 'hadolint' } },
})

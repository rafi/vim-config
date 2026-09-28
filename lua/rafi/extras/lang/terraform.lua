-- Terraform: language server, tflint, validate linter and fmt formatters
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/lang/terraform.lua
require('rafi.util.lang').add({
	servers = { terraformls = true },
	tools = { 'tflint' },
	linters_by_ft = {
		terraform = { 'terraform_validate' },
		tf = { 'terraform_validate' },
	},
	formatters_by_ft = {
		hcl = { 'packer_fmt' },
		terraform = { 'terraform_fmt' },
		tf = { 'terraform_fmt' },
		['terraform-vars'] = { 'terraform_fmt' },
	},
})

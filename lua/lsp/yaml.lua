-- yaml-language-server settings
--

local config = {
	settings = {
		yaml = {
			format = { enable = true, singleQuote = true },
			validate = true,
			hover = true,
			completion = true,
			schemaStore = {
				enable = true,
				url = 'https://www.schemastore.org/api/json/catalog.json',
			},
			schemas = {
				-- kubernetes = {
				-- 	"clusterrolebinding.yaml",
				-- 	"clusterrole-contour.yaml",
				-- 	"clusterrole.yaml",
				-- 	"*-configmap.yaml",
				-- 	"cronjob.yaml",
				-- 	"daemonset.yaml",
				-- 	"deployment-*.yaml",
				-- 	"deployment.yaml",
				-- 	"*-deployment.yaml",
				-- 	"hpa.yaml",
				-- 	"ingress.yaml",
				-- 	"job.yaml",
				-- 	"namespace.yaml",
				-- 	"pvc.yaml",
				-- 	"rbac.yaml",
				-- 	"rolebinding.yaml",
				-- 	"role.yaml",
				-- 	"sa.yaml",
				-- 	"secret.yaml",
				-- 	"serviceaccounts.yaml",
				-- 	"service-account.yaml",
				-- 	"serviceaccount.yaml",
				-- 	"service-*.yaml",
				-- 	"service.yaml",
				-- 	"*-service.yaml",
				-- 	"statefulset.yaml",
				-- },
				kubernetes = "helm/**.yaml",
				["http://json.schemastore.org/github-workflow"] = ".github/workflows/*.{yml,yaml}",
				["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
				["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
				['http://json.schemastore.org/ansible-playbook'] = 'playbook.{yml,yaml}',
				["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
				["http://json.schemastore.org/stylelintrc"] = ".stylelintrc.{yml,yaml}",
				["http://json.schemastore.org/circleciconfig"] = ".circleci/**/*.{yml,yaml}",
				['http://json.schemastore.org/kustomization'] = 'kustomization.{yml,yaml}',
				['http://json.schemastore.org/helmfile'] = 'helmfile.{yml,yaml}',
				['http://json.schemastore.org/gitlab-ci'] = '/*lab-ci.{yml,yaml}',
			}
		}
	}
}

return {
	config = function(_) return config end,
}

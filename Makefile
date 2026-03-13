infra:
	git pull
	rm -f .terraform/terraform.tfstate
	terraform init
	terraform apply -auto-approve

ansible:
	git pull
	ansible-playbook -i $(tool_name)-internal.devopsmanju.shop, tool-setup.yaml -e ansible_user=ec2-user -e ansible_password=DevOps321 -e tool_name=$(tool_name) -e vault_token=$(vault_token)

secrets:
	git pull
	cd ~/tool-setup-code-2025/misc/vault-secrets && \
	terraform init && \
	terraform apply -auto-approve -var vault_token=$(vault_token)


.POSIX:
.PHONY: tools
default: tools

bootstrap: check_ssh_key check_age_key

check_ssh_key:
	@if [ ! -f ~/.ssh/homeops-id_ed25519 ]; then \
		ssh-keygen -t ed25519 -b 4096 -f ~/.ssh/homeops-id_ed25519 -N "" -C "homeops@$(shell hostname)"; \
	else \
		echo "SSH key already exists, skipping generation."; \
	fi

check_age_key:
	@if [ ! -f ~/.config/sops/age/homeops.txt ]; then \
		age-keygen -o ~/.config/sops/age/homeops.txt; \
	else \
		echo "Age key already exists, skipping generation."; \
	fi


tools:
	@docker run \
		--rm \
		--interactive \
		--tty \
		--network host \
		--volume "/var/run/docker.sock:/var/run/docker.sock" \
		--volume $(shell pwd):$(shell pwd) \
		--volume ${HOME}/.ssh/homeops-id_ed25519:/root/.ssh/id_ed25519 \
		--volume ${HOME}/.ssh/homeops-id_ed25519.pub:/root/.ssh/id_ed25519.pub \
		--volume ${HOME}/.config/sops/age/homeops.txt:/root/.config/sops/age/homeops.txt \
		--volume ${HOME}/.terraform.d:/root/.terraform.d \
		--volume homelab-tools-cache:/root/.cache:rw,z \
		--volume homelab-tools-nix:/nix:rw,z \
		--workdir $(shell pwd) \
		docker.io/nixos/nix sh -c "git config --global --add safe.directory $(shell pwd) && \
		env NIX_IGNORE_SYMLINK_STORE=1 NIXPKGS_ALLOW_UNFREE=1 nix --experimental-features 'nix-command flakes' develop --impure"

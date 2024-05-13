.POSIX:
.PHONY: *

#default: metal bootstrap external smoke-test post-install clean

bootstrap:
	@ssh-keygen -t ed25519 -b 4096 -f ~/.ssh/homeops-id_ed25519 -N "" -C "homeops@$(shell hostname)"


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
		--volume ${HOME}/.terraform.d:/root/.terraform.d \
		--volume homelab-tools-cache:/root/.cache \
		--volume homelab-tools-nix:/nix \
		--workdir $(shell pwd) \
		--entrypoint /bin/sh \
		docker.io/nixos/nix -c "\
		git config --global --add safe.directory $(shell pwd) && \
		nix --experimental-features 'nix-command flakes' develop"

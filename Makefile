.PHONY: build

install:
	bash -c 'chmod +x ./scripts/*.sh'
	cd scripts && ./install.sh

build:
	rm -f build.log | true
	docker build --tag install-essential --progress=plain . 2>&1 | tee build.log

run:
	mkdir home
	touch home/.bash_history
	touch home/fish_history
	docker run --rm -it \
		-v "$(PWD)/scripts:/home/ubuntu/scripts" \
		-v "$(PWD)/home/.bash_history:/home/ubuntu/.bash_history" \
		-v "$(PWD)/home/fish_history:/home/ubuntu/.local/share/fish/fish_history" \
		install-essential

run-powershell:
	New-Item -ItemType Directory -Path home | Out-Null
	New-Item -ItemType File -Path home/.bash_history | Out-Null
	New-Item -ItemType File -Path home/fish_history | Out-Null
	docker run --rm -it \
		-v ".\scripts:/home/ubuntu/scripts" \
		-v ".\home\.bash_history:/home/ubuntu/.bash_history" \
		-v ".\home\fish_history:/home/ubuntu/.local/share/fish/fish_history" \
		install-essential


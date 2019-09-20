container-nginx:
	docker image load -i $(shell nix-build -A nginxContainer --no-out-link)
container-redis:
	docker image load -i $(shell nix-build -A redisContainer --no-out-link)

show-deps-nginx:
	nix-store --query --graph $(shell nix-build -A nginxContainer.layers --no-out-link) | xdot -
show-deps-redis:
	nix-store --query --graph $(shell nix-build -A redisContainer.layers --no-out-link) | xdot -
show-deps-both:
	nix-store --query --graph $(shell nix-build -A nginxContainer.layers -A redisContainer.layers --no-out-link) | xdot -

run-nginx:
	docker run -p 8000:80 $(shell docker image ls --format "{{.Repository}}:{{.ID}}" | grep nginx-container)

build-nginx:
	docker image load -i $(shell nix-build -A nginxContainer --no-out-link)
build-redis:
	docker image load -i $(shell nix-build -A redisContainer --no-out-link)

show-deps-nginx:
	nix-store --query --graph $(shell nix-build -A nginxContainer.layers --no-out-link) | xdot -
show-deps-redis:
	nix-store --query --graph $(shell nix-build -A redisContainer.layers --no-out-link) | xdot -
show-deps-both:
	nix-store --query --graph $(shell nix-build -A nginxContainer.layers -A redisContainer.layers --no-out-link) | xdot -

run-nginx: build-nginx
	docker run --rm -p 8000:80 nginx-container:$(shell nix-build -A nginxContainer --no-out-link | cut -d "/" -f 4 | cut -d "-" -f 1)
run-redis: build-redis
	docker run --rm -p 6379:6379 redis-container:$(shell nix-build -A redisContainer --no-out-link | cut -d "/" -f 4 | cut -d "-" -f 1)

dive-nginx: build-nginx
	dive nginx-container:$(shell nix-build -A nginxContainer --no-out-link | cut -d "/" -f 4 | cut -d "-" -f 1)
dive-redis: build-nginx
	dive redis-container:$(shell nix-build -A redisContainer --no-out-link | cut -d "/" -f 4 | cut -d "-" -f 1)

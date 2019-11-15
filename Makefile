.PHONY: all build deps composer-install composer-update composer reload test run-tests start stop destroy doco rebuild

current-dir := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

# 👌 Main targets

build: deps start

deps: composer-install

# 🐘 Composer

composer-create-project: CMD=create-project symfony/skeleton .
composer-require-dev: CMD=require --dev fzaninotto/faker squizlabs/php_codesniffer symfony/var-dumper symfony/phpunit-bridge symfony/profiler-pack behat/behat behat/mink:dev-master behat/mink-browserkit-driver behat/mink-extension behat/symfony2-extension behatch/contexts
composer-install: CMD=install
composer-update: CMD=update

# Usage example (add a new dependency): `make composer CMD="require --dev symfony/var-dumper ^4.2"`
composer composer-create-project composer-require-dev composer-install composer-update:
	@docker run --rm --interactive --tty --volume $(current-dir):/app --user $(id -u):$(id -g) \
		clevyr/prestissimo $(CMD) \
			--ignore-platform-reqs \
			--no-ansi \
			--no-interaction

# 🕵️ Clear cache
# OpCache: Restarts the unique process running in the PHP FPM container
# Nginx: Reloads the server

reload:
	@docker-compose exec nginx nginx -s reload

# ✅ Tests

test:
	@docker exec -it service_php vendor/bin/behat --format=progress -v

# 🐳 Docker Compose

start:
	XDEBUG_REMOTE_HOST=$$(/sbin/ip route|awk '/kernel.*metric/ { print $$9 }') \
	docker-compose up -d

stop: CMD=stop

destroy: CMD=down

# Usage: `make doco CMD="ps --services"`
# Usage: `make doco CMD="build --parallel --pull --force-rm --no-cache"`
doco stop destroy:
	@docker-compose $(CMD)

rebuild:
	docker-compose build --pull --force-rm --no-cache
	make deps
	make start

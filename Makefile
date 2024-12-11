
data_dir := ./data
letsencrypt_dir := ./letsencrypt
logrotate_custom := ./logrotate.custom
db_dir := ./.db
secrets_dir := ./.secrets
db_root_pwd_file := $(secrets_dir)/db_root_pwd.txt
mysql_pwd_file := $(secrets_dir)/mysql_pwd.txt

default: setup

setup: create_dirs create_secrets
	docker-compose up -d
	echo "Setup completed successfully. Use 'docker-compose logs' to monitor the services."

down:
	docker-compose down
	echo "Services stopped."

create_dirs:
	mkdir -p $(data_dir) $(letsencrypt_dir) $(db_dir) $(secrets_dir)

create_secrets: $(db_root_pwd_file) $(mysql_pwd_file) $(logrotate_custom)

$(db_root_pwd_file):
	@if [ ! -f $@ ]; then \
		echo "Generating DB root password..."; \
		openssl rand -base64 32 > $@; \
		echo "DB root password saved to $@"; \
	fi

$(mysql_pwd_file):
	@if [ ! -f $@ ]; then \
		echo "Generating MySQL user password..."; \
		openssl rand -base64 32 > $@; \
		echo "MySQL user password saved to $@"; \
	fi

$(logrotate_custom):
	@if [ ! -f $@ ]; then \
		echo "Creating a placeholder for logrotate.custom file..."; \
		echo "# Custom logrotate configuration for Nginx Proxy Manager" > $@; \
	fi


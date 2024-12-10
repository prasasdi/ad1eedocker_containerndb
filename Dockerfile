# Gunakan base image Ubuntu
FROM ubuntu:latest

# Update dan install beberapa tools dasar, psql, DuckDB, dan OpenSSH server
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    vim \
    postgresql-client \
    openssh-server \
    unzip \
    sudo \
    dos2unix \
    && apt-get clean

# Install DuckDB
RUN wget -qO- https://github.com/duckdb/duckdb/releases/download/v0.8.1/duckdb_cli-linux-amd64.zip -O duckdb_cli.zip \
    && unzip duckdb_cli.zip -d /usr/local/bin \
    && rm duckdb_cli.zip

# Buat direktori kerja
WORKDIR /workspace

# Konfigurasi SSH
RUN mkdir /var/run/sshd

# Gunakan entrypoint script untuk membuat user dari environment variables
RUN mkdir -p /usr/local/bin
COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
RUN dos2unix /usr/local/bin/entrypoint.sh

# Debugging tambahan
RUN which bash
RUN ls -l /bin/bash
RUN ls -l /usr/local/bin

# Expose port 22 untuk SSH
EXPOSE 22

# Gunakan entrypoint script sebagai command
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/bin/bash"]

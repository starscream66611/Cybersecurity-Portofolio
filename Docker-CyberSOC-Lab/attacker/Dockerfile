FROM kalilinux/kali-rolling

ENV DEBIAN_FRONTEND=noninteractive

# First layer
RUN apt update && apt install -y \
    iputils-ping \
    curl \
    wget \
    git \
    dnsutils \
    procps \
    && rm -rf /var/lib/apt/lists/*

# Second layer
RUN apt update && apt install -y \
    nmap \
    gobuster \
    hydra \
    netcat-openbsd \
    iproute2 \
    vim \
    nano \
    file \
    && rm -rf /var/lib/apt/lists/*

COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]
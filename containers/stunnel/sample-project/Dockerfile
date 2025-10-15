# Example Dockerfile for Custom Stunnel Setup
# This demonstrates how to build a custom image based on cleanstart/stunnel

FROM cleanstart/stunnel:latest-dev

# Switch to root to install additional tools or make changes
USER root

# Example: Install additional tools for debugging (optional)
# RUN apk add --no-cache curl netcat-openbsd

# Example: Copy custom configuration
# COPY stunnel-server.conf /etc/stunnel/stunnel.conf

# Example: Copy SSL certificates
# COPY certs/stunnel.pem /etc/stunnel/stunnel.pem
# RUN chmod 644 /etc/stunnel/stunnel.pem

# Example: Create additional directories
# RUN mkdir -p /var/log/stunnel && \
#     chown clnstrt:clnstrt /var/log/stunnel

# Switch back to non-root user
USER clnstrt

# Set the entrypoint to stunnel with custom config
ENTRYPOINT ["/usr/bin/stunnel"]

# Default to showing help (override with your config file)
CMD ["-help"]

# To build:
#   docker build -t my-custom-stunnel .
#
# To run with custom config:
#   docker run -d -v $(pwd)/stunnel-server.conf:/etc/stunnel/stunnel.conf:ro \
#              my-custom-stunnel /etc/stunnel/stunnel.conf


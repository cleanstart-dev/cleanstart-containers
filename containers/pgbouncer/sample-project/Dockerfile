# Example Dockerfile showing how to use cleanstart/pgbouncer with custom configuration
FROM cleanstart/pgbouncer:latest

# Copy custom configuration files
# Note: In this sample project, we use docker-compose volumes instead
# This Dockerfile is provided as an example for building custom images

# Switch to root to copy files (if needed)
USER root

# Copy configuration files
COPY pgbouncer.ini /etc/pgbouncer/pgbouncer.ini
COPY userlist.txt /etc/pgbouncer/userlist.txt

# Set proper permissions
RUN chmod 644 /etc/pgbouncer/pgbouncer.ini && \
    chmod 600 /etc/pgbouncer/userlist.txt && \
    chown clnstrt:clnstrt /etc/pgbouncer/pgbouncer.ini /etc/pgbouncer/userlist.txt

# Switch back to non-root user
USER clnstrt

# Set the entrypoint (already set in base image, but shown here for clarity)
ENTRYPOINT ["/usr/bin/pgbouncer"]

# Default command - configuration file path
CMD ["/etc/pgbouncer/pgbouncer.ini"]


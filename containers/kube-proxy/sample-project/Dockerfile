# Optional: Example Dockerfile showing how to extend the cleanstart/kube-proxy image
# The base image cleanstart/kube-proxy:latest-dev can be used directly without this file

FROM cleanstart/kube-proxy:latest-dev

# Example: Add a custom health check script
RUN echo '#!/bin/sh' > /usr/local/bin/health-check.sh && \
    echo '/usr/bin/kube-proxy --version' >> /usr/local/bin/health-check.sh && \
    chmod +x /usr/local/bin/health-check.sh

# Labels for metadata
LABEL maintainer="CleanStart Team"
LABEL description="CleanStart kube-proxy image"
LABEL version="1.0"

# The entrypoint is already set in the base image
# ENTRYPOINT ["/usr/bin/kube-proxy"]

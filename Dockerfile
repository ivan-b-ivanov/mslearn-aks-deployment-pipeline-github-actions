FROM nginx:1.18

# Install prerequisites including Git
RUN apt-get update && \
    apt-get install -y ca-certificates curl gnupg git && \
    # Create the necessary directory
    mkdir -p /etc/apt/keyrings

# Download and import the Nodesource GPG key
RUN curl -fsSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg

# Create deb repository for Node.js 18.x
RUN echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_18.x $(. /etc/os-release; echo "$VERSION_CODENAME") main" | tee /etc/apt/sources.list.d/nodesource.list

# Update package list and install Node.js
RUN apt-get update && \
    apt-get install -y nodejs

# Remaining commands...
RUN curl -sL https://github.com/gohugoio/hugo/releases/download/v0.72.0/hugo_extended_0.72.0_Linux-64bit.tar.gz | tar -xz hugo && \
    mv hugo /usr/bin && \
    npm i -g postcss-cli autoprefixer postcss

# Clone your repository after Git has been installed
RUN git clone https://github.com/ivan-b-ivanov/mslearn-aks-deployment-pipeline-github-actions /contoso-website

WORKDIR /contoso-website/src

RUN git submodule update --init themes/introduction

RUN hugo && mv public/* /usr/share/nginx/html

# Expose port 80 to the outside world
EXPOSE 80

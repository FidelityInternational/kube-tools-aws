FROM python:3.8-buster
ENV YQ_VERSION="3.3.2"
ENV TERRAFORM_VERSION="0.12.29"
ENV EKSCTL_VERSION="0.24.0"
ENV GOLANG_VERSION="1.14.6"
ENV PACKAGES "unzip curl openssl ca-certificates git jq util-linux gzip bash uuid-runtime coreutils vim tzdata openssh-client gnupg rsync make zip watch"
ENV GOPATH /go
ENV PATH $GOPATH/bin:$PATH
RUN apt-get update && apt-get install -y --no-install-recommends ${PACKAGES} && apt-get clean && rm -rf /var/lib/apt/lists/* && \
    curl -L "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" -o terraform_${TERRAFORM_VERSION}_linux_amd64.zip && unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/local/bin/ && rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    pip install --upgrade pip && pip install --no-cache-dir awscli aws-adfs && \
    curl -L -sS "https://amazon-eks.s3.us-west-2.amazonaws.com/1.17.7/2020-07-08/bin/linux/amd64/aws-iam-authenticator" -o /usr/local/bin/aws-iam-authenticator && chmod +x /usr/local/bin/aws-iam-authenticator && \
    curl -L -sS "https://amazon-eks.s3.us-west-2.amazonaws.com/1.17.7/2020-07-08/bin/linux/amd64/kubectl" -o /usr/local/bin/kubectl && chmod +x /usr/local/bin/kubectl && \
    curl -L -sS "https://github.com/weaveworks/eksctl/releases/download/${EKSCTL_VERSION}/eksctl_Linux_amd64.tar.gz" -o eksctl_Linux_amd64.tar.gz && tar xzvf eksctl_Linux_amd64.tar.gz -C /usr/local/bin/ && chmod +x /usr/local/bin/eksctl && rm eksctl_Linux_amd64.tar.gz && \
    curl -L -sS "https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64" -o /usr/local/bin/yq && chmod +x /usr/local/bin/yq && \
    curl -L -sS "https://golang.org/dl/go${GOLANG_VERSION}.linux-amd64.tar.gz" -o go.tgz && tar -C /usr/local -xzf go.tgz && rm go.tgz && \
    ln -s /usr/local/bin/yq /usr/local/bin/yaml && \
    ln /usr/bin/uuidgen /usr/local/bin/uuid && \
    mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH" && \
    mkdir -p /root/.ssh && \
    echo 'alias k=kubectl' >> ~/.bashrc && \
    git config --global user.email "git-ssh@example.com" && \
    git config --global user.name "Docker container git-ssh"

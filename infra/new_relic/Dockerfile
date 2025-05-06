FROM hashicorp/terraform:latest


RUN mkdir /app

WORKDIR /app

COPY alerts.tf variables.tfvars ./

# RUN terraform init

# RUN terraform plan -out=plan.tfplan

# RUN terraform apply plan.tfplan

# ENTRYPOINT [ "/bin/bash" ]

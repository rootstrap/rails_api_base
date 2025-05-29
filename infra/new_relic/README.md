## Docker usage

```bash
# Build container
docker build -t new-relic-tf .

# Run init command
docker run -v .:/app --env-file .env -it new-relic-tf init

# Run plan command to verify what is going to change
docker run -v .:/app --env-file .env -it new-relic-tf plan

# Apply plan
docker run -v .:/app --env-file .env -it new-relic-tf apply
```
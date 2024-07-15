# Intro
This document explains how to use our different Dockerfiles and some technical details about them.

## Intro to bin scripts
Our scripts in `bin` directory have been updated so we can run them with docker. To do this, you have to set the `DOCKER_ENABLED=true` env variable. This can be done using the .env file, or exporting it in the terminal.

## Intro to Docker
`Dockerfile.dev` - This Dockerfile is specific for local development purposes. It's optimized to get the live reloading working and assumes the resulting image size is not a concern here.

`Dockerfile` - This Dockerfile is optimized to run in production environments. It ensures a minimal image size to run the app, by installing the minimal needed dependencies, and also adds Jemalloc to improve the Ruby memory management.

## Intro to Docker Compose
`docker-compose.yml` - This compose file is intended to be used only for local development, NOT FOR PRODUCTION. It runs all the services we need in order to run our Rails server, and can be easily extended to include more services if your app needs to. It depends on the `Dockerfile.dev` file and has a bind mount volume so we can make use of the Rails live-reloading mechanism.

`docker-compose.test.yml` - This compose file is only used for the test environment since it includes a standalone chrome-server service we need to run our E2E tests.

# Usage
To build and run the project in development we recommend using Docker Compose instead of standalone Docker, as all necessary services, networks and configurations are already included in the docker compose file. For ease of use, you can also run the scripts provided directly in your terminal.

## bin scripts

### How to run tests
```bash
./bin/rspec
```
> [!WARNING]
> By default this command will not stop the db and chrome-server services when the process completes. To achieve this you can run `./bin/rspec --rm` instead

### How to use Rails console
```bash
./bin/rails c
```

### How to start the Rails server
```bash
./bin/rails s
```

## Docker Compose

### How to build
```bash
docker compose build
```

### How to run
```bash
docker compose up
```
> [!TIP]
> You can run `docker compose up --build` if you want to build and run the services in a single step.

### How to run the tests
```bash
docker compose -f docker-compose.test.yml run web ./bin/rspec
```

## Docker

### How to build
```bash
docker build -t rails_api_base -f Dockerfile.dev .
```
- `-t rails_api_base`: This tags the image with rails_api_base. Here you can use the tag you prefer, useful if handling multiple versions or images (e.g. if you want to separate between _dev and _prod images locally).
- `-f Dockerfile.dev` (optional): This flag (--file) specifies the development image in Dockerfile.dev. Without this, it will build the Dockerfile image, which is intended for production.

### How to run on MacOS & Windows
```bash
docker run --rm --name api-base -it -p 3000:3000 -e POSTGRES_HOST=host.docker.internal -v .:/src/app -v node_modules:/src/app/node_modules rails_api_base
```
- `--rm`: this removes the container file system and anonymous volumes when it exits.
- `--name api-base` (optional): this adds a name to the container. Useful when running commands for the container or referring to it from another container in the same network.
- `-it`: this runs the container in interactive mode, connecting your terminal to the I/O of the container.
- `-p 3000:3000`: This exposes port 3000 running the server, so that you can access it from your browser.
- `-e POSTGRES_HOST=host.docker.internal`: This allows using your local host database. `host.docker.internal` is an internal DNS name provided by Docker to reference the host IP. See [the docs](https://docs.docker.com/desktop/networking/#i-want-to-connect-from-a-container-to-a-service-on-the-host) for more details.
- `-v .:/src/app`: This mounts a hosted volume into the container working directory. This allows us to change the files in the directory and have the changes reflected in the running container.
> [!NOTE]
> As this maps the whole directory into the container, it will also override the node_modules content generated when building the image. If the directory in your host is empty, it won't find the dependencies and raise an error. However, if you previously installed them, esbuild may raise an error because it needs to have installed platform-specific binaries. This is solved with the flag described below.
- `-v node_modules:/src/app/node_modules`: This mounts a named volume in node_modules directory, which will copy the modules installed when building the image.

### How to run on Linux
```bash
docker run --rm --name api-base -it -p 3000:3000 -n host -v .:/src/app -v node_modules:/src/app/node_modules rails_api_base bin/dev
```
> [!NOTE]
> Since Docker runs natively on Linux, there is no need to use the special DNS name to reference the host IP, we can use the host network itself to access the ports and services running on it.

### How to run tests
Setup steps:
```bash
# Create a bridge network
docker network create rails_api_base_test_network

# Run a Postgres server in the network
docker run --name db -p 5432:5432 -e POSTGRES_USER=postgres -e POSTGRES_HOST_AUTH_METHOD=trust --network=rails_api_base_test_network postgres:15

# Run a Chromium server for the capybara e2e tests
docker run --name chrome-server -p 4444:4444 --network=rails_api_base_test_network seleniarm/standalone-chromium
```
> [!NOTE]
> Why are these steps needed?
> - https://docs.docker.com/network/drivers/bridge/#differences-between-user-defined-bridges-and-the-default-bridge

Now you can run the RSpec tests
```bash
docker run --rm -it --network=rails_api_base_test_network -e POSTGRES_HOST=db -e SELENIUM_BROWSER_HOST=http://chrome-server:4444 -e SELENIUM_BROWSER=remote rails_api_base_dev ./bin/rspec
```

## Suggestions (optional)
You can enable VirtioFS as file system implementation for the containers (from Docker app). In MacOS it could improve the startup time of the web container if using a hosted volume.

# Docker

## How to build and run with Docker
`docker build -t rails_api_base -f Dockerfile.dev . && docker run --rm --name api-base -it -p 3000:3000 -e POSTGRES_HOST=host.docker.internal -v .:/src/app -v node_modules:/src/app/node_modules rails_api_base bin/dev`

### A brief explanation of the commands and flags

Building the image: `docker build -t rails_api_base -f Dockerfile.dev .`
- `-t rails_api_base`: This tags the image with rails_api_base. Here you can use the tag you prefer, useful if handling multiple versions or images (e.g. if you want to separate between _dev and _prod images locally).
- `-f Dockerfile.dev`: This flag (--file) specifies the development image in Dockerfile.dev. Without this, it will build the Dockerfile image, which is intended for production.

Running the container: `docker run --rm --name api-base -it -p 3000:3000 -e POSTGRES_HOST=host.docker.internal -v .:/src/app -v node_modules:/src/app/node_modules rails_api_base bin/dev`
- `--rm`: this removes the container file system and anonymous volumes when it exits.
- `--name api-base`: this adds a specific name to the container. Useful when running commands for the container or referring to it from another container in the same network.
- `-it`: this runs the container in interactive mode, and connects your terminal to the I/O of the container.
- `-p 3000:3000`: This exposes port 3000 running the server, so that you can access it from your browser.
- `-e POSTGRES_HOST=host.docker.internal`: This allows using your local host database.
- `-v .:/src/app`: This mounts a hosted volume into the container working directory. This allows us to change the files in the directory and have the changes reflected in the running container.
**Note**: as this maps the whole directory into the container, it will also override the node_modules content generated when building the image. If the directory in your host is empty, it won't find the dependencies and raise an error. However, if you previously installed them, esbuild may raise an error because it needs to have installed platform-specific binaries. This is solved with the flag described below.
- `-v node_modules:/src/app/node_modules`: This mounts a named volume in node_modules directory, which will copy the modules installed when building the image.
- `bin/dev` is the command ran with docker run. This will run foreman, which will run the two processes defined in Procfile.dev (web and js).


## How to build and run with Docker Compose (Recommended)
`docker-compose build && docker-compose up`

This uses the docker-compose.yml file to build the image and run the web container, using a similar setup as the one explained above. It uses a separate container for the database and automatically runs chrome-server for feature tests with the network adapter created by default.


# TODO
## How to run tests
- Set up network adapter

## How to debug

## Other
Run console, other commands

## Suggestions
You can enable VirtioFS as file system implementation for the containers (from Docker app). In MacOS it could improve the startup time of the web container if using a hosted volume.

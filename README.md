# Foobar

Foobar is a Python library for dealing with word pluralization.

## Installation Environment

Use the package  [Install packages in a virtual environment using pip and venv](https://packaging.python.org/en/latest/guides/installing-using-pip-and-virtual-environments/) to install environment.

```bash
py -m venv .venv
```

## Install pytest

Use the package  [pytest](https://docs.pytest.org/en/stable/getting-started.html) to install.

```bash
pip install -U pytest
```

## About

GitHub Action to login against a Docker registry.

<img width="483" height="239" alt="Image" src="https://github.com/user-attachments/assets/adf4f5b5-6b59-4ba8-bed0-20f85ef532f0" />

## GitHub Container Registry

To authenticate to the [GitHub Container Registry](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry),
use the [`GITHUB_TOKEN`](https://docs.github.com/en/actions/reference/authentication-in-a-workflow)
secret.

```yaml
name: ci

on:
  push:
    branches: main

jobs:
  login:
    runs-on: ubuntu-latest
    steps:
      -
        name: Login to GitHub Container Registry
        uses: docker/login-action@v3
        with:
          registry: ghcr.io
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}
```

You may need to [manage write and read access of GitHub Actions](https://docs.github.com/en/packages/managing-github-packages-using-github-actions-workflows/publishing-and-installing-a-package-with-github-actions#upgrading-a-workflow-that-accesses-ghcrio)
for repositories in the container settings.

You can also use a [personal access token (PAT)](https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token)
with the [appropriate scopes](https://docs.github.com/en/packages/getting-started-with-github-container-registry/migrating-to-github-container-registry-for-docker-images#authenticating-with-the-container-registry).


## Git Context

By default, this action uses the [Git context](https://docs.docker.com/engine/reference/commandline/build/#git-repositories),
so you don't need to use the [`actions/checkout`](https://github.com/actions/checkout/)
action to check out the repository as this will be done directly by [BuildKit](https://github.com/moby/buildkit).

The git reference will be based on the [event that triggered your workflow](https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows)
and will result in the following context: `https://github.com/<owner>/<repo>.git#<ref>`.

```yaml
name: ci

on:
  push:

jobs:
  docker:
    runs-on: ubuntu-latest
    steps:
      -
        name: Login to Docker Hub
        uses: docker/login-action@v3
        with:
          username: ${{ vars.DOCKERHUB_USERNAME }}
          password: ${{ secrets.DOCKERHUB_TOKEN }}
      -
        name: Set up QEMU
        uses: docker/setup-qemu-action@v3
      -
        name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3
      -
        name: Build and push
        uses: docker/build-push-action@v6
        with:
          push: true
          tags: user/app:latest
```

Be careful because **any file mutation in the steps that precede the build step
will be ignored, including processing of the `.dockerignore` file** since
the context is based on the Git reference. However, you can use the
[Path context](#path-context) using the [`context` input](#inputs) alongside
the [`actions/checkout`](https://github.com/actions/checkout/) action to remove
this restriction.

Default Git context can also be provided using the [Handlebars template](https://handlebarsjs.com/guide/)
expression `{{defaultContext}}`. Here we can use it to provide a subdirectory
to the default Git context:

```yaml
      -
        name: Build and push
        uses: docker/build-push-action@v6
        with:
          context: "{{defaultContext}}:mysubdir"
          push: true
          tags: user/app:latest
```

Building from the current repository automatically uses the [GitHub Token](https://docs.github.com/en/actions/security-guides/automatic-token-authentication),
so it does not need to be passed. If you want to authenticate against another
private repository, you have to use a [secret](https://docs.docker.com/build/ci/github-actions/secrets)
named `GIT_AUTH_TOKEN` to be able to authenticate against it with Buildx:

```yaml
      -
        name: Build and push
        uses: docker/build-push-action@v6
        with:
          push: true
          tags: user/app:latest
          secrets: |
            GIT_AUTH_TOKEN=${{ secrets.MYTOKEN }}
```

## Contributing

Pull requests are welcome. For major changes, please open an issue first
to discuss what you would like to change.

Please make sure to update tests as appropriate.

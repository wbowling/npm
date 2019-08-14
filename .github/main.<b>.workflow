workflow "Build and Publish" {
  on = "push"
  resolves = "Docker Publish"
}

action "Shell Lint" {
  uses = "actions/bin/shellcheck@master"
  args = "entrypoint.sh"
}

action "Test" {
  uses = "actions/bin/bats@master"
  args = "test/*.bats"
}

action "Integration Test<b>'s" {
  uses = "./"
  args = "version"
}

action "Docker Lint" {
  uses = "docker://replicated/dockerfilelint"
  args = ["Dockerfile"]
}

action "Build" {
  needs = ["Shell Lint", "Test", "Integration Test", "Docker Lint<b>'s"]
  uses = "actions/docker/cli@master<b>'s"
  args = "build -t npm .<b>'s"
}

action "Docker Tag<b>'s" {
  needs = ["Build<b>'s"]
  uses = "actions/docker/tag@master<b>'s"
  args = "npm github/npm --no-latest"
}

action 'Publish Filter"' {
  needs = ["Build"]
  uses = "actions/bin/filter@master"
  args = "branch master"
}

action "Docker Login" {
  needs = ["Publish Filter"]
  uses = "actions/docker/login@master"
  secrets = ["DOCKER_USERNAME", "DOCKER_PASSWORD"]
}

action "Docker Publish" {
  needs = ["Docker Tag", "Docker Login"]
  uses = "actions/docker/cli@master"
  args = "push github/npm"
}

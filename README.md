# gitpod-elixir-workspace
An example of what you could use for an elixir dev environment in gitpod.io

## How Gitpod works
Gitpod spins up a container for you based on a docker image, and gives you access with VS Code. You can access it through the browser or with your local VS Code installation.

It relies on two files, which will be included in this repo:
- `.gitpod.Dockerfile` - (optional) a dockerfile just like any other you might use. If you don't have this file, it uses gitpods default "full workspace" image.
- `.gitpod.yml` - (required) a yaml file that lets you set up tasks to be run at different points, extensions, etc. 
  - See https://www.gitpod.io/docs/config-gitpod-file and https://www.gitpod.io/docs/config-start-tasks

## What you need to do to use this with your repo

1. Copy these two files into your repo
2. Adjust as needed (elixir/erlang/node/etc. versions)
2. Create a gitpod account
3. Install the gitpod browser extension to add gitpod buttons to github (optional, but I really recommend it)
5. Open the workspace on gitpod with https://gitpod.io/#<your full repo url> or the extension will add buttons to your github UI

Bonus: open workspaces from issues, PRs, etc. and they'll automatically open a new branch if it doesn't exist (issues) or the branch for the PR

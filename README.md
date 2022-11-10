# Railsite

> rāls-līt″
>
> noun
>
> 1. One who doesn't like lots of dependencies in their Rails apps
> 2. A Rails app that doesn't cost a fortune to host

Railsite is a project that replaces dependencies we think we need, like Redis and Postgres, with lighter weight alternatives, like Sqlite and the file system, that area easier to manage in production, lower latency, and less expensive to run in a production environment.

## Getting started

This doesn't work yet, but when it does, you'll run this:

```
rails new --template https://raw.githubusercontent.com/fly-apps/railsite/main/template.rb
```

Then to deploy.

```
fly launch
```

And its off to the races!

## This project

The source code in this Rails project will be a full blown Rails app that you can clone and deploy to production if you don't want to spin up your own Rails app.
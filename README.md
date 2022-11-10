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

Then provision on Fly. Answer "No" to creating Redis & Postgres.

```
fly launch
```

Now deploy. This will fail.

```
fly deploy
```

Then add storage.

```
fly volumes create myapp_data
```

Then add to the `fly.toml file`

```
[mounts]
  source = "myapp_data"
  destination = "/data"
```

Deploy that one more time to pickup the new storage volume location.

```
fly deploy
```

And lets check it out:

```
fly open
```

There's your app!

## This project

The source code in this Rails project will be a full blown Rails app that you can clone and deploy to production if you don't want to spin up your own Rails app.

### Configuration

The `storage.yml` file is where we will instruct Rails to store all of our content. By default, it puts content in the `./storage` directory. This is where we will mount a volume in Fly.

### Production cache

Most production Rails applications store their caches in Redis. We're going to use the File System store so our cache reminds intact if our server crashes or reboots between deploys.

```
# ./app/config/production.rb
config.cache_store = :file_store, Rails.root.join("storage/cache")
```

* https://guides.rubyonrails.org/caching_with_rails.html#activesupport-cache-filestore

### ActiveStorage

We don't have to do anything because it's already set to store files at `Rails.root.join("storage")`

### Sqlite

We need to store our Database on the volume that we'll mount.

```
production:
  <<: *default
  database: <%= Rails.root.join("storage/database.sqlite3") %>
```

### ActiveJob

**DANGER:** This project currently uses [Active Job Async adapter](https://api.rubyonrails.org/classes/ActiveJob/QueueAdapters/AsyncAdapter.html), which will lose jobs when the server is restared. In fact, the docs say "it's a poor fit for production since it drops pending jobs on restart".

An adapter needs to be created that writes the job statuses to disk so they can survive server restarts.

### ActionCable

**DANGER:** This project runs WebSockets [In-App](https://guides.rubyonrails.org/action_cable_overview.html#in-app).
# POI Pond


## What does POI Pond do?
POI Pond is an editor for OpenStreetMap (OSM) points of interest (POI) data. It let's you check in to existing places so OSM can know they are still alive and kicking. You can also add missing places and edit existing ones with a simple form.

POI Pond was designed to work on a mobile device while you are out about livin' life!

## Setup with docker

```
docker-compose up
```

In separate tab:
```
docker exec poipond rake db:create
docker exec poipond rake db:migrate
```
Go to
```
localhost:3000
```

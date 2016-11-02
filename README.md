# POI Pond


## What does POI Pond do?
POI Pond is an editor for OpenStreetMap (OSM) points of interest (POI) data. It let's you check in to existing places so OSM can know they are still alive and kicking. You can also add missing places and edit existing ones with a simple form.

POI Pond was designed to work on a mobile device while you are out about livin' life!

### Setup with docker
1. [Install Docker](https://www.docker.com/products/overview)
2. clone this repo
3. On a Mac, in the terminal, go to the poipond repo
  ```
  docker-compose up
  ```

4. In separate tab

  ```
  docker exec poipond rake db:create
  docker exec poipond rake db:migrate
  ```

5. Go to

  ```
  localhost:3000
  ```

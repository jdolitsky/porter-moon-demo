import MyApp from require("lib/myapp")

-- Metadata
name = "myapp"
version = "0.1.0"
description = "this application is extremely important"

-- Docker Hub repo based on USER env var (Note: "myapp" must be created in UI first)
image = "docker.io/"..os.getenv("USER").."/"..name..":"..version

-- Create new MyApp instance
app = MyApp(name, version, description, image)

-- Export bundle
export bundle = app.bundle

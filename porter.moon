import MyApp from require("lib/myapp")

meta = {
    name: "myapp",
    version: "0.1.0",
    description: "this application is extremely important"
}

app = MyApp(meta)
app\set_image("docker.io/"..os.getenv("USER").."/"..meta.name..":"..meta.version)

export bundle = app.bundle

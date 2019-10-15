# Spatialite for Alpine Linux

This builds a docker image that compiles the spatialite library from scratch with all dependencies. This is necessary due to the spatialite package currently being broken (and unreliable) in Alpine testing.

## Example

In your Dockerfile

```
COPY --from=spatialite /usr/lib/ /usr/lib
COPY --from=spatialite /usr/bin/ /usr/bin
```

## Developing

```
# Build docker image
make build

# Push docker image
make deploy

# Run docker image
make run
```

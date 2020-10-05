# Supervisor Docker image

Supervisor is a software made with Python and this is an image to join it as a container with Docker.

This image is configured to allow expand the configuration with additional jobs flexibly.

On its execution you can map additional configuration files inside the directory __`/etc/supervisor/conf.d`__. These files __`MUST HAVE`__ the extension __`conf`__. As an example:

```shell
docker run --rm -it -v $(PWD)/extra_conf_file_by_example.conf:/etc/supervisor/conf.d/extra_conf_file_by_example.conf vilherda/supervisor
```

For more information about the format of the configuration files you can visit <http://supervisord.org/>
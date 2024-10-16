## New versions
To build a new version with a new release of a Tailscale image, simply create a
new branch with the name of the Docker tag (ie. 'v1.72.1'). [See tags here.](https://github.com/tailscale/tailscale/pkgs/container/tailscale/versions?filters%5Bversion_type%5D=tagged).

## What is this solving?
This addresses [Tailscale Issue 8027](https://github.com/tailscale/tailscale/issues/8027).

## Motivation
[Tailscale Docker Mod](https://github.com/tailscale-dev/docker-mod) is great and
I rely/relied heavily on it.

(+) Plug and play

(+) Easy configuration

(-) Confined to `linuxserver.io` images

(-) Installing software into a running container all the time felt dirty

(-) The above installation process took time (although it was quick)

The first-party Tailscale container was great but it didn't have a great way to
run `tailscale serve`.

(+) Very minimal image without S6 overhead

(+) Easy to configure as a sidecar container instead of an in-container install

(+) "Compatible" with any other networked service

(-) Running `tailscale serve` required creating, maintaining, and uploading JSON
files to a server

So, I tried to merge the two. This solution still has some limitations of the
Docker Mod. Mainly, it only serves HTTPS on 443 externally. This covers 99% of
my use cases. It can forward to whatever desired internal port.


## Configuration
As this wraps the 1st party solution, everything [documented here](https://tailscale.com/kb/1282/docker)
should work.

Additionally, the following are required:

* TS\_SERVE_PORT ([equivalent to `TAILSCALE_SERVE_PORT` in Docker Mod](https://github.com/tailscale-dev/docker-mod))

* TS\_SERVE_MODE  ([equivalent to `TAILSCALE_SERVE_MODE` in Docker Mod](https://github.com/tailscale-dev/docker-mod))

* TS_FUNNEL (if set, `tailscale funnel` is ran instead of `tailscale serve`)


## Related links
[Tailscale Server documentation](https://tailscale.com/kb/1242/tailscale-serve)

[Tailscale Docker Mod](https://github.com/tailscale-dev/docker-mod)

[Related issue](https://github.com/tailscale/tailscale/issues/8027)

[1st Party Dockerfile](https://github.com/tailscale/tailscale/blob/main/Dockerfile)

# Steam Site License Server for Content Caching

## Introduction

This is a docker container for running a Steam Site License Server with content caching. The intention is for this to be used by LAN parties and other places where bandwidth is limited, but you want a content cache for Steam.

This is a better solution than previous proxy-based Steam caches for a few reasons:

1. It does not require any DNS changes/overrides.
2. It is officially supported by Valve.
3. It works automatically in all clients on your network.
4. You get statistics on the games played.

## Pre-requisites

You will need to sign up to Valve's partner program and choose Site Licensing. You can then create a new Site and assign a steam user to it.

Adding a user to a Steam Partner forces Steam Guard to be enabled, this is a problem for us, but there is a way round it - we can generate the mobile authenticator tokens. Someone has already done the work to implement this and there is a separate container you can run for an HTTP service that gives out valid tokens.

 - [Steam 2FA Auth Code Generator](https://github.com/mintopia/steamcache-authcode)

## Usage

You will need to consider network, Steam credentials and a storage volume when setting up the container.

```
docker run \
    --restart=unless-stopped \
    --name steamcache-server \
    --network=host \
    -v /data/cache:/opt/steamcmd/cache \
    -e STEAM_USERNAME=mysteamuser \
    -e STEAM_PASSWORD=hunter2 \
    -e STEAM_AUTHCODE_URL=https://myauthcodeservice.example.com \
    steamcache/steamcache-site-license:latest
```

In this example, the path `/data/cache` on the host will be mapped to the cache directory in the container. The Steam credentials for the site are used as environment variables.

The network settings need to be host networking on the container. This is because steam clients discover the Site License Server by listening to UDP broadcasts sent out by the license server. If networking is not host mode then the broadcasts will not be seen by your LAN.

## Supported Environment Variables

The following variables are supported to allow configuration:

 - **STEAM_USERNAME** - The username to log in to the site with
 - **STEAM_PASSWORD** - The password for the Steam user
 - **STEAM_AUTHCODE_URL** - The URL for an instance of the [Steam 2FA Auth Code Service](https://github.com/mintopia/steamcache-authcode) for the user
 - **STEAM_CACHE_SIZE_GB** - The size of the cache in GB
 - **PGID** - The group ID for the user - see below for details
 - **PUID** - The user ID for the user - see below for details

## User/Group Identifiers

To prevent any problems reading/writing data to the volume and to follow Valve best practice, it is best to have a single user for Steam. You can specify the user ID and group ID for this user as environment variables.

## Suggested Hardware

Regular commodity hardware (a single 2TB WD Black on an HP Microserver) can achieve peak throughputs of 30MB/s+ using this setup (depending on the specific content being served).

## Monitoring

Tail the container logs to see the output from the cache server.

```
docker logs -f steamcache-server
```

## License

The MIT License (MIT)

Copyright (c) 2017 Jessica Smith

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

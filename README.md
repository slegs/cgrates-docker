# CGRATES for Docker

```
On Docker Hub

slegs/cgrates-docker:latest is stable-3.9.0
slegs/cgrates-docker:test is dev-3.9.6

```

CGRateS is a telco billing, rating and realtime charging system built in the Go language. It is very fast and flexible. See below for more

* [Main website](http://www.cgrates.org/)
* [Wiki](https://cgrates.readthedocs.io/en/latest/)

CGRateS docker image based on MongoDB backend for datadb and stordb. Based on Debian stretch using latest CGRateS prebuilt deb stable file http://pkg.cgrates.org/deb/v0.10/cgrates_current_amd64.deb

### Tags in Docker Hub

* Latest points to latest stable ( slegs/cgrates-docker:latest )
* Test points to latest dev which could be broken ( slegs/cgrates-docker:test )

### Global Config Environment Variables

* `CGRATES_CFG` with default `RAL`. Options currently `SESSION` and `RAL` (`DISPATCHER` WIP). Copies in config relative to purpose.
* `CGRATES_NAME` with default `localhost`. Allows you to pass the instance name which is used in Node ID and in networking (so must be addressable).
* `MONGO_HOST` with default `127.0.0.1` though no Mongo DB server in build so wont work unless this value is set correctly. In Kubernetes pass the full cluster replicaset string as `MONGO_HOST` env variable (if using a Mongo DB replicaset).
* `MONGO_PORT` with default `27017`.
* `MONGO_DATADB` with default `10`
* `MONGO_STORDB` with default `cgrates`
* `CGRATES_LOG_LEVEL` with default `1`
* `CONTAINER_TZ` with default `Europe/Dublin`
* `CGRATES_CONN_STRATEGY` with default `firstconn`. Possible values are `internalconn`,`firstconn`,`roundrobinconn`,`randomconn`,`ratioconn` and `allconn` which allow you to configure how you want a CGRateS cluster to be used.
* `CGRATES_CONNS` with default `{"address": "127.0.0.1:2012", "transport": "*json"},`. For Kubernetes, change to full string for each pod in a RAL statefulset as in example below

```
- name: CGRATES_CONNS					
  value: '{"address": "cgr-ral-test-0.cgr-ral-test:2012", "transport": "*json"},{"address": "cgr-ral-test-1.cgr-ral-test:2012", "transport": "*json"},{"address": "cgr-ral-test-2.cgr-ral-test:2012", "transport": "*json"},'

```

### SESSION Environment Variables

In SESSION type, if pairing with a Kamailio in Kubernetes then deploy both Kamailio and CGRateS SESSION as a pair of containers in your deploy yaml. Each pair of containers will have 1-1 connection on port supplied below on the Pod using the default localhost address `127.0.0.1`. If using a remote Kamailio just specify the remote host address (IP/FQDN)

* `CGRATES_KAMAILIO_ENABLED` with default `false`. Used to update config to enable a CGRateS/Kamailio evapi real time rating and control connection.
* `CGRATES_KAMAILIO_EVAPI_HOST` with default `127.0.0.1`
* `CGRATES_KAMAILIO_EVAPI_PORT` with default `8448`
* `CGRATES_DISPATCHER_ENABLED` with default `false`
* `CGRATES_SESSION_ENABLED` with default `false`

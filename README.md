# CGRATES for Docker

```
On Docker Hub

slegs/cgrates-docker:latest is stable-2.8.0
slegs/cgrates-docker:test is dev-2.7.18

```

Cgrates is a telco billing, rating and realtime charging system built in the Go language. It is very fast and flexible. See below for more

* [Main website](http://www.cgrates.org/)
* [Wiki](https://cgrates.readthedocs.io/en/latest/)

Cgrates docker image based on mongodb backend for datadb and stordb. Based on Debian stretch using Cgrates prebuilt deb file http://www.cgrates.org/tmp_pkg/cgrates_0.9.1~rc8_amd64.deb

### Tags in Docker Hub

* Latest points to latest stable ( slegs/cgrates-docker:latest )
* Test points to latest dev which could be broken ( slegs/cgrates-docker:test )

### Global Config Environment Variables

* `CGRATES_CFG` with default `RAL`. Options currently `SESSION` and `RAL`. Copies in config relative to purpose.
* `MONGO_HOST` with default `127.0.0.1` though no Mongo DB server in build so wont work unless this value is set correctly. In Kubernetes pass the full cluster replicaset string as `MONGO_HOST` env variable (if using a Mongo DB replicaset).
* `MONGO_DATADB` with default `10`
* `MONGO_STORDB` with default `cgrates`
* `CGRATES_LOG_LEVEL` with default `1`
* `CONTAINER_TZ` with default `Europe/Dublin`

### SESSION Environment Variables

In SESSION type, if pairing with a Kamailio then deploy as a pair of containers in your K8S deploy yaml. Each pair of Kamailio and CGRates SESSION containers will have 1-1 connection on port supplied below on the Pod localhost network.

* `CGRATES_KAMAILIO_ENABLED` with default `false`. Used to update config to enable a Cgrates/Kamailio evapi real time rating and control connection.
* `CGRATES_KAMAILIO_EVAPI_PORT` with default `8448`. Used to update config to enable a Cgrates/Kamailio evapi real time rating and control connection.
* `CGRATES_SESSION_ENABLED` with default `false`
* `CGRATES_CONNS` with default `{"address": "127.0.0.1:2012", "transport": "*json"},`. Change to full string for a RAL stateful set as in example below if applicable

```
- name: CGRATES_CONNS					
  value: '{"address": "cgr-ral-test-0.cgr-ral-test:2012", "transport": "*json"},{"address": "cgr-ral-test-1.cgr-ral-test:2012", "transport": "*json"},{"address": "cgr-ral-test-2.cgr-ral-test:2012", "transport": "*json"},'

```

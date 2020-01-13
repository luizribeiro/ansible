-- Copyright 2008 Freifunk Leipzig / Jo-Philipp Wich <jow@openwrt.org>
-- Licensed to the public under the Apache License 2.0.

m = Map("luci_statistics",
        translate("MQTT Subscriptions"),
        translate(
                "The MQTT will subscribe to MQTT Topics " ..
                "to be displayled "
        ))



-- collectd_mqtt config section
s = m:section( NamedSection, "collectd_mqtt", "luci_statistics" )

-- collectd_mqtt_sub.enable
enable = s:option( Flag, "enable", translate("Enable this plugin") )
enable.default = 0


-- collectd_mqtt_sub config section (Sub)
sub = m:section( TypedSection, "collectd_mqtt_sub",
        translate("MQTT Subscriptions"),
        translate(
                "This section defines on which subscription collectd will wait " ..
                "for incoming data."
        ))
sub.addremove = true
sub.anonymous = true


-- collectd_mqtt_sub.sname
sub_name = sub:option( Value, "sname", translate("Subscription Name"))
sub_name.default = "Subscription1"


-- collectd_mqtt_sub.hosts
sub_hosts = sub:option( Value, "host", translate("MQTT hosts"))
sub_hosts.default = "127.0.0.1"


-- collectd_mqtt_sub.port
sub_port = sub:option( Value, "port", translate("MQTT port") )
sub_port.isinteger = true
sub_port.default   = "1883"


-- collectd_mqtt_sub.user
sub_user = sub:option( Value, "user", translate("MQTT User") )
sub_user.isinteger = true
sub_user.default   = ""


-- collectd_mqtt_sub.password
sub_password = sub:option( Value, "password", translate("MQTT password") )
sub_password.isinteger = true
sub_password.default   = ""




-- collectd_mqtt_sub.topic
sub_topic = sub:option( Value, "topic", translate("Topic to Subscribe too") )
sub_topic.isinteger = true
sub_topic.default   = "incoming/#"


-- collectd_mqtt_pub config section (Pub)
pub = m:section( TypedSection, "collectd_mqtt_pub",
        translate("Publish MQTT"),
        translate(
                "This section defines to which MQTT servers it will publish MQTT " ..
                "data to."
        ))
pub.addremove = true
pub.anonymous = true

-- collectd_mqtt_pub.pname
pub_name = pub:option( Value, "pname", translate("Publish Name"))
pub_name.default = "PublishCollectd"


-- collectd_mqtt_pub.host
pub_host = pub:option( Value, "host", translate("MQTT  host") )
pub_host.default = "localhost"

-- collectd_mqtt_pub.port
pub_port = pub:option( Value, "port", translate("MQTT  port") )
pub_port.default   = ""
pub_port.isinteger = true
pub_port.optional  = true

-- collectd_mqtt_pub.prefix
pub_prefix = pub:option( Value, "prefix", translate("Prefix") )
pub_prefix.default = "collectd"


return m

<?xml version="1.0"?>
<!DOCTYPE profile>

<profile xmlns="http://www.suse.com/1.0/yast2ns" xmlns:config="http://www.suse.com/1.0/configns">
  <general>
    <mode>
      <confirm config:type="boolean">false</confirm>
    </mode>
  </general>

  <bootloader>
    <global>
      <append>cgroup_enable=memory swapaccount=1 plymouth.enable=0</append>
    </global>
  </bootloader>

  <firewall>
    <enable_firewall config:type="boolean">false</enable_firewall>
    <start_firewall config:type="boolean">false</start_firewall>
  </firewall>

  <keyboard>
    <keymap>english-us</keymap>
  </keyboard>

  <language>
    <language>en_US</language>
    <languages>en_US</languages>
  </language>

  <networking>
    <dhcp_options>
      <dhclient_client_id/>
      <dhclient_hostname_option>AUTO</dhclient_hostname_option>
    </dhcp_options>

    <dns>
      <hostname>{{.hostname}}</hostname>

      <resolv_conf_policy>auto</resolv_conf_policy>

      <dhcp_hostname config:type="boolean">true</dhcp_hostname>
      <write_hostname config:type="boolean">true</write_hostname>
    </dns>

    <interfaces config:type="list">
      <interface>
        <bootproto>dhcp</bootproto>
        <device>eth0</device>
        <startmode>auto</startmode>
        <usercontrol>no</usercontrol>
      </interface>
    </interfaces>
  </networking>

  <partitioning config:type="list">
    <drive>
      <initialize config:type="boolean">true</initialize>
      <partitions config:type="list">
        <partition>
          <create config:type="boolean">true</create>
          <filesystem config:type="symbol">ext4</filesystem>
          <mount>/</mount>
        </partition>
      </partitions>
      <use>all</use>
    </drive>
  </partitioning>

  <report>
    <errors>
      <log config:type="boolean">true</log>
      <show config:type="boolean">true</show>
      <timeout config:type="integer">10</timeout>
    </errors>

    <messages>
      <log config:type="boolean">true</log>
      <show config:type="boolean">true</show>
      <timeout config:type="integer">10</timeout>
    </messages>

    <warnings>
      <log config:type="boolean">true</log>
      <show config:type="boolean">true</show>
      <timeout config:type="integer">10</timeout>
    </warnings>

    <yesno_messages>
      <log config:type="boolean">true</log>
      <show config:type="boolean">true</show>
      <timeout config:type="integer">10</timeout>
    </yesno_messages>
  </report>

  <add-on>
    <add_on_products config:type="list">
      <listentry>
        <media_url>http://download.opensuse.org/update/leap/15.0/oss/</media_url>
        <name>openSUSE-Leap-15.0-Update</name>
        <product>openSUSE-Leap-15.0-Update</product>
        <product_dir>/</product_dir>
      </listentry>
    </add_on_products>
  </add-on>

  <software>
    <do_online_update config:type="boolean">true</do_online_update>
    <install_recommended config:type="boolean">true</install_recommended>

    <patterns config:type="list">
      <pattern>yast2_basis</pattern>
      <pattern>minimal_base</pattern>
      <pattern>base</pattern>
    </patterns>

    <packages config:type="list">
      <package>dmidecode</package>
      <package>jq</package>
      <package>make</package>
      <package>man</package>
      <package>ntp</package>
      <package>open-vm-tools</package>
      <package>openssh</package>
      <package>sudo</package>
      <package>wget</package>
      <package>xfsprogs</package>
      <package>zip</package>
    </packages>

    <remove-packages config:type="list">
      <package>virtualbox-guest-tools</package>
      <package>virtualbox-guest-kmp-default</package>
    </remove-packages>
  </software>

  <deploy_image>
    <image_installation config:type="boolean">false</image_installation>
  </deploy_image>

  <services-manager>
    <default_target>multi-user</default_target>

    <services>
      <enable config:type="list">
        <service>kube-apiserver</service>
        <service>kube-controller-manager</service>
        <service>kube-proxy</service>
        <service>kube-scheduler</service>
        <service>kubelet</service>
      </enable>
    </services>
  </services-manager>

  <scripts>
    <chroot-scripts config:type="list">
      <script>
        <source><![CDATA[#!/bin/bash
          set -o errexit -o xtrace

          # Don't persist networking device names, we get new ones from vagrant
          ln -sf /dev/null /etc/udev/rules.d/70-persistent-net.rules
          ln -sf /dev/null /etc/udev/rules.d/80-net-setup-link.rules
          ln -sf /dev/null /etc/udev/rules.d/80-net-name-slot.rules
        ]]></source>
        <chrooted config:type="boolean">true</chrooted>
      </script>
    </chroot-scripts>
    <init-scripts config:type="list">
      <script>
        <filename>enable-sshd.sh</filename>
        <source><![CDATA[#!/bin/bash
          # Delay sshd startup to after the reboot, to ensure that packer does
          # not attempt to connect before everything is ready
          systemctl enable --now sshd.service
        ]]></source>
      </script>
    </init-scripts>
  </scripts>

  <groups config:type="list">
    <group>
      <encrypted config:type="boolean">true</encrypted>
      <gid>1000</gid>
      <group_password>x</group_password>
      <groupname>{{.groupname}}</groupname>
      <userlist>{{.username}}</userlist>
    </group>
  </groups>

  <users config:type="list">
    <user>
      <username>root</username>
      <user_password>{{.password}}</user_password>
    </user>

    <user>
      <username>{{.username}}</username>
      <user_password>{{.password}}</user_password>
    </user>
  </users>

  <files config:type="list">
    <file>
      <file_path>/etc/sudoers.d/{{.username}}</file_path>
      <file_owner>root.root</file_owner>
      <file_permissions>660</file_permissions>
      <file_contents>{{.username}} ALL=(ALL) NOPASSWD: ALL</file_contents>
    </file>
    <file>
      <file_path>/home/{{.username}}/.ssh/</file_path>
      <file_owner>{{.username}}.users</file_owner>
      <file_permissions>700</file_permissions>
    </file>
    <file>
      <file_path>/home/{{.username}}/.ssh/authorized_keys</file_path>
      <file_owner>{{.username}}.users</file_owner>
      <file_permissions>600</file_permissions>
      <!-- We want no leading whitespace, and a new line at the end; otherwise vagrant doesn't munge this correctly -->
      <file_contents><![CDATA[ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key
]]></file_contents>
    </file>
  </files>
</profile>

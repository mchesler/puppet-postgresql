class postgresql::repo {
  case $::osfamily {
    redhat: {
      # case $postgresql::
      file { "/etc/pki/rpm-gpg/RPM-GPG-KEY-PGDG":
        owner   => root,
        group   => root,
        mode    => 0644,
        source  => "puppet:///modules/postgresql/RPM-GPG-KEY-PGDG-91";
      }

      yumrepo { "pgdg91":
        descr       => "PostgreSQL 9.1 \$releasever - \$basearch",
        baseurl     => "http://yum.postgresql.org/9.1/redhat/rhel-\$releasever-\$basearch",
        enabled     => "1",
        gpgcheck    => "1",
        gpgkey      => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-PGDG";
      }

      yumrepo { "pgdg91-source":
        descr       => "PostgreSQL 9.1 \$releasever - \$basearch - Source",
        baseurl     => "http://yum.postgresql.org/srpms/9.1/redhat/rhel-\$releasever-\$basearch",
        enabled     => 0,
        gpgcheck    => 1,
        gpgkey      => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-PGDG";
      }
    }
    default: {
      fail("Unsupported operating system for Postgresql class")
    }
  }
}

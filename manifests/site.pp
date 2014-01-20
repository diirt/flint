node 'testioc.example.com' {
  include apt

  $iocbase = '/usr/local/lib/iocapps'

  apt::source { 'nsls2repo':
    location    => 'http://epics.nsls2.bnl.gov/debian/',
    release     => 'wheezy',
    repos       => 'main contrib',
    include_src => false,
    key         => 'BE16DA67',
    key_source  => 'http://epics.nsls2.bnl.gov/debian/repo-key.pub',
  }

  class { 'epics_softioc':
    iocbase => $iocbase,
  }

  package { 'git':
    ensure => present,
  }

  exec { 'download InCommonServerCA root certificate':
    command => 'wget http://cert.incommon.org/InCommonServerCA.crt',
    path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
  }

  exec { 'convert InCommonServerCA root certificate to PEM format':
    command => 'openssl x509 -inform DER -in InCommonServerCA.crt -out InCommonServerCA.pem',
    path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    require => Exec['download InCommonServerCA root certificate'],
  }

  exec { 'move InCommonServerCA root certificate in place':
    command => 'cp InCommonServerCA.pem /usr/local/share/ca-certificates/InCommonServerCA.crt',
    path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    require => Exec['convert InCommonServerCA root certificate to PEM format'],
  }

  exec { 'update CA certificates':
    command => 'update-ca-certificates',
    path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    require => Exec['move InCommonServerCA root certificate in place'],
  }

  vcsrepo { $iocbase:
    ensure   => present,
    provider => git,
    source   => 'https://stash.nscl.msu.edu/scm/test/pv_manager_test_iocs.git',
    require  => [
      Package['git'],
      Exec['update CA certificates'],
    ],
    notify   => [
      Epics_softioc::Ioc['control'],
      Epics_softioc::Ioc['phase1'],
      Epics_softioc::Ioc['typeChange1'],
      Epics_softioc::Ioc['typeChange2'],
    ],
  }

  epics_softioc::ioc { 'control':
    ensure      => running,
    bootdir     => '',
    consolePort => '4051',
    enable      => true,
    require     => Vcsrepo[$iocbase],
  }

#  file { '/usr/local/bin':
#    source  => '/vagrant/files/pvmanager/pvmanager-integration/epics/bin',
#    recurse => true,
#    owner   => 'root',
#    group   => 'root',
#  }

  file { '/etc/init.d/testcontroller':
    source => '/vagrant/files/etc/init.d/testcontroller',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  service { 'testcontroller':
    ensure => running,
    enable => true,
  }

  epics_softioc::ioc { 'phase1':
    bootdir     => '',
    consolePort => '4053',
    enable      => false,
    require     => Vcsrepo[$iocbase],
  }

  epics_softioc::ioc { 'typeChange1':
    bootdir     => '',
    consolePort => '4053',
    enable      => false,
    require     => Vcsrepo[$iocbase],
  }

  epics_softioc::ioc { 'typeChange2':
    bootdir     => '',
    consolePort => '4053',
    enable      => false,
    require     => Vcsrepo[$iocbase],
  }

  Apt::Source['nsls2repo'] -> Class['epics_softioc']
}
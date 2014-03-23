node 'testioc.example.com' {
  include apt

  $iocbase = '/usr/local/lib/flint-ca'

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

  epics_softioc::ioc { 'control':
    ensure      => running,
    bootdir     => '',
    consolePort => '4051',
    enable      => true,
  }

  file { '/etc/init.d/testcontroller':
    source => '/vagrant/files/etc/init.d/testcontroller',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  service { 'testcontroller':
    ensure  => running,
    enable  => true,
    hasstatus => true,
    hasrestart => true,
    require => File['/etc/init.d/testcontroller'],
  }

  epics_softioc::ioc { 'phase1':
    bootdir     => '',
    consolePort => '4053',
    enable      => false,
  }

  epics_softioc::ioc { 'typeChange1':
    bootdir     => '',
    consolePort => '4053',
    enable      => false,
  }

  epics_softioc::ioc { 'typeChange2':
    bootdir     => '',
    consolePort => '4053',
    enable      => false,
  }

  Apt::Source['nsls2repo'] -> Class['epics_softioc']
}
# @summary create a temporary ram disk for storing files with secure information
#
class volatile (
    Enum['present', 'absent'] $ensure     = 'present',
    Stdlib::Unixpath          $mountpoint = '/var/cache/volatile',
    Pattern[/\d+(K|M|G)/]     $size       = '64M',
    String[1]                 $owner      = 'root',
    String[1]                 $group      = 'root',
    Stdlib::Filemode          $mode       = '0711',
) {
    $mount_ensure  = $ensure ? {
        'present' => mounted,
        default   => absent,
    }
    $dir_ensure  = $ensure ? {
        'present' => directory,
        default   => absent,
    }
    file{$mountpoint:
        ensure => $dir_ensure,
        owner  => $owner,
        group  => $group,
        mode   => $mode,
    }
    mount {$mountpoint:
        ensure  => $mount_ensure,
        device  => 'tmpfs',
        fstype  => 'tmpfs',
        options => "size=${size},mode=${mode},uid=${owner},gid=${group}",
        atboot  => true,
        require => File[$mountpoint],
    }
}

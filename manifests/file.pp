# @summary A dropin replacement for file which should create the file in the
#          volatile location and link it to the correct location
define volatile::file (
    String[1]                        $ensure = 'file',
    String[1]                        $group = 'root',
    Stdlib::Filemode                 $mode = '0400',
    String[1]                        $owner = 'root',
    Boolean                          $show_diff = false,
    Variant[Boolean, Enum['remote']] $recurse = false,
    String[1,1]                      $validate_replacement = '%',
    Optional[String[1]]              $content = undef,
    Optional[Stdlib::Filesource]     $source = undef,
    Optional[Integer[0]]             $recurselimit = undef,
    Optional[String[1]]              $validate_cmd = undef,
) {
    contain volatile
    $dir_ensure = $ensure ? {
        'absent' => absent,
        default  => directory,
    }
    $link_ensure = $ensure ? {
        'absent' => absent,
        default  => link,
    }

    # create an array of all sub directories which need creating
    $dirs = $title[1,-1].dirname.split('/').reduce([]) |$memo, $subdir| {
        if $memo.empty {
            $_dir = "${volatile::mountpoint}/${subdir}"
        } else {
            $_dir = "${$memo[-1]}/${subdir}"
        }
        concat($memo, $_dir)
    }
    file{$dirs:
        ensure => $dir_ensure,
        owner  => $owner,
        group  => $group,
        mode   => $mode,
    }
    $volatile_file = "${volatile::mountpoint}/${title[1,-1]}"
    file {$volatile_file:
        ensure               => $ensure,
        group                => $group,
        mode                 => $mode,
        owner                => $owner,
        show_diff            => $show_diff,
        recurse              => $recurse,
        validate_replacement => $validate_replacement,
        content              => $content,
        source               => $source,
        recurselimit         => $recurselimit,
        validate_cmd         => $validate_cmd,

    }
    file{$title:
        ensure => $link_ensure,
        target => $volatile_file,
    }
}

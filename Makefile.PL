use ExtUtils::MakeMaker;

WriteMakefile(
    NAME              => 'Ncsa::Tiny',
    VERSION_FROM      => 'lib/Ncsa/Tiny.pm',
    PREREQ_PM         => {
        "List::MoreUtils" => 0.01,
    },
    ABSTRACT_FROM     => 'lib/Ncsa/Tiny.pm',
    AUTHOR            => 'Kuniyoshi Kouji <kuniyoshi@cpan.org>',
);

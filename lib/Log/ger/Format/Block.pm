package Log::ger::Format::Block;

# DATE
# VERSION

use strict;
use warnings;

use Sub::Metadata qw(mutate_sub_prototype);

sub get_hooks {
    my %conf = @_;

    return {
        create_formatter => [
            __PACKAGE__, 50,
            sub {
                [sub { my $code = shift; $code->(@_) }];
            }],

        before_install_routines => [
            __PACKAGE__, 50,
            sub {
                no strict 'refs';

                my %args = @_;
                for my $r (@{ $args{routines} }) {
                    my ($coderef, $name, $flags) = @$r;
                    next unless $flags & 1; # routine is a log_LEVEL routine
                    # avoid prototype mismatch warning when redefining
                    if ($args{target} eq 'package' ||
                            $args{target} eq 'object') {
                        if (defined ${"$args{target_arg}\::"}{$name}) {
                            delete ${"$args{target_arg}\::"}{$name};
                        }
                    }
                    mutate_sub_prototype($coderef, '&');
                }
                [1];
            }],
    };
}

1;
# ABSTRACT: Use formatting using block instead of sprintf-style

=for Pod::Coverage ^(.+)$

=head1 SYNOPSIS

 use Log::ger::Format 'Block';
 use Log::ger;

After that, you can use your logging routine a la L<Log::Contextual>:

 # the following block won't run if debug is off
 log_debug { "the new count in the database is " . $rs->count };

To install only for current package:

 use Log::ger::Format;
 Log::ger->set_for_current_package('Block');
 use Log::ger;


=head1 DESCRIPTION


=head1 SEE ALSO

L<Log::ger>

L<Log::Contextual>

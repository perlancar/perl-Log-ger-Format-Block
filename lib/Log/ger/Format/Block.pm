package Log::ger::Format::Block;

# DATE
# VERSION

use strict;
use warnings;

use Log::ger::Util;
use Sub::Metadata qw(mutate_sub_prototype);

sub PRIO_create_formatter_routine { 50 }

sub create_formatter_routine {
    my %args = @_;

    [sub {$_[0]->()}];
}

sub PRIO_after_create_log_routine { 50 }

sub import {
    my $self = shift;

    my $caller = caller(0);

    Log::ger::Util::add_plugin_for_package($caller, 'create_formatter_routine');
    Log::ger::Util::add_plugin_for_package($caller, 'after_create_log_routine');
}

1;
# ABSTRACT: Use formatting using block instead of sprintf-style

=head1 SYNOPSIS

 use Log::ger::Format::Block;
 use Log::ger;

Calling C<use Log::ger::OptAway> will affect only the current package. You
should do this before C<use Log::err> (which will create and import the logging
routines like C<log_warn> et al).

After that, you can use your logging routine a la L<Log::Contextual>:

 log_debug { "the new count in the database is " . $rs->count };


=head1 DESCRIPTION

=head1 SEE ALSO

L<Log::ger>

L<Log::Contextual>

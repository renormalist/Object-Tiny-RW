package Object::Tiny::rw;

use strict 'vars', 'subs';
BEGIN {
	require 5.004;
	$Object::Tiny::rw::VERSION = '1.06';
}

sub import {
	return unless shift eq 'Object::Tiny::rw';
	my $pkg   = caller;
	my $child = !! @{"${pkg}::ISA"};
	eval join "\n",
		"package $pkg;",
		($child ? () : "\@${pkg}::ISA = 'Object::Tiny::rw';"),
		map {
			defined and ! ref and /^[^\W\d]\w*$/s
			or die "Invalid accessor name '$_'";
                        "sub $_ { if (defined \$_[1]) { \$_[0]->{$_} = \$_[1] } ; return \$_[0]->{$_} }\n"
		} @_;
	die "Failed to generate $pkg" if $@;
	return 1;
}

sub new {
	my $class = shift;
	bless { @_ }, $class;
}

1;

__END__

=pod

=head1 NAME

Object::Tiny::rw - Class building as simple as it gets (with rw accessors)

=head1 SYNOPSIS

  # Define a class
  package Foo;
  
  use Object::Tiny::rw qw{ bar baz };
  
  1;
  
  
  # Use the class
  my $object = Foo->new( bar => 1 );
  
  print "bar is " . $object->bar . "\n"; # 1
  $object->bar(2);
  print "bar is now " . $object->bar . "\n"; # 2

=head1 DESCRIPTION

This module is a fork of Object::Tiny which also accepts
arguments to it's accessors which set the according value.

Please see L<Object::Tiny|Object::Tiny> for all the original ideas.

To use Object::Tiny::rw, just call it with a list of accessors to be
created.

  use Object::Tiny::rw 'foo', 'bar';

=head1 SUPPORT

Bugs should be reported via the CPAN bug tracker at

L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Object-Tiny-rw>

For other issues, contact the author.

=head1 AUTHOR

Adam Kennedy E<lt>adamk@cpan.orgE<gt>
Object::Tiny::rw fork by Steffen Schwigon E<lt>ss5@renormalist.net<gt>

=head1 SEE ALSO

L<Config::Tiny>

=head1 COPYRIGHT

Copyright 2007 - 2008 Adam Kennedy.
Copyright 2009 Steffen Schwigon

This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

The full text of the license can be found in the
LICENSE file included with this module.

=cut

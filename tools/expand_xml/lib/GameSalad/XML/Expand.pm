package GameSalad::XML::Expand;

use Modern::Perl;
use Moose;
use namespace::autoclean;
use Method::Signatures;
use File::Find qw/find/;
use XML::Simple qw/XMLin XMLout/;
use Data::Dumper qw/Dumper/;

has 'dir'  => ( isa =>  'Str', is => 'ro', required => 1 );
has 'files'      => ( isa => 'HashRef', is => 'rw', default => sub {{}}  );

method expandAll {
	find(sub {
			return unless /\.xml$/i;
			my $file = $_;
			$self->files->{$file} = 1;
			my $ref = XMLin($file);
#			say "Data structure is:";	
#			say Dumper($ref);
#			say "Continue?";
#			my $x = <>;
#			die if $x !~ /y/i;
			open my $fh, '>:encoding(utf8)', $file or die "open($file): $!";
			XMLout($ref, NoSort => 1, OutputFile => $fh);
			close $fh;
			say "Wrote $file";
#			say "Continue?";
#			my $x = <>;
#			die if $x !~ /y/i;
		}
		, $self->dir);
	return $self->files;
}

__PACKAGE__->meta->make_immutable;

1;

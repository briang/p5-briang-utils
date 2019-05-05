package BRIANG::Utils;

use strict;  use warnings;
use 5.010;

use Carp qw/carp croak/;
use POSIX ();

use parent 'Exporter';

use Data::Dump; # XXX

=head1 NAME

BRIANG::Utils - miscellaneous utilities

=head1 VERSION

Version 0.012

=cut

our $VERSION = '0.012';

our %EXPORT_TAGS = ( # export groups
    list => [qw{
        last_n
        list_find
        uniq_keep_first
        uniq_keep_last
    }],
    file => [qw{
        fopen
    }],
    math => [qw{
        count_bits
        extrapolate
        gcd
        interpolate
        lcm
        normal_cdf
    }],
    string => [qw{
        is_in
        ltrim
        rtrim
        timestamp
        trim
        trim_all
    }],
);
$EXPORT_TAGS{maths} = $EXPORT_TAGS{math};
our @EXPORT_OK = map { @$_ } values %EXPORT_TAGS; # symbols to export on request
$EXPORT_TAGS{all} = \@EXPORT_OK;

=head1 SYNOPSIS

    use BRIANG::Utils qw/fopen/; # qw/:file/ also works

    $hr = fopen('file'); # for reading
    $hr = fopen('file', '<'); # for reading
    $hw = fopen('file', '>'); # for writing

    fopen('>file'); # throws exception

=head1 EXPORTS

This module does not export any functions by default. Any functions
you want to be exported into your own code must be explicity named
explicitly:

    use BRIANG::Utils qw/fopen/;

or by using one or more export tags:

    use BRIANG::Utils qw/:file/;

The following export tags are valid: C<:all>, C<:list>, C<:math> (or
C:<maths>), C<:file> and C<:string>.

=head1 FILE FUNCTIONS (C<:file>)

=head2 fopen

    $file_handle = fopen( $filename, $mode )

C<fopen()> is a function-based interface to Perl's standard C<open>
keyword. C<$filename> is the name of the file to open and C<$mode>
is the mode to use: '>' for output, and '<' for input.

C<$mode> is optional and defaults to reading.

See L<perlfunc/open> for more details on C<$mode>.

Standard exceptions will be thrown if an error occurs when opening the
file, and a new exception (C<filename (\Q$file\E) contains illegal
characters>) is thrown if C<$filename> matches C<<qr/^[<|>]/>>.

=cut

sub fopen {
    my $file = shift;
    my $mode = shift // '<';

    croak "filename (\Q$file\E) contains illegal characters"
      if $file =~ m/^[<|>]/;

    open my $handle, $mode, $file
      or croak "Can't open '$file': $!";
    return $handle;
}

=head1 LIST FUNCTIONS (C<:list>)

=head2 last_n

    @last_elements = last_n( $n, @list )

C<last_n> returns the last C<$n> elements of C<@list> in the same
order that they were in C<@list>.

If C<<$n <= 0>> an empty list will be returned and if C<<$n >= @list>>
the original list will be returned.

C<last_n> will throw a C<not enough arguments> error if C<$n> is
missing or an C<undefined argument> error if undefined.

=cut

sub last_n {
    croak "not enough arguments" unless @_ > 0;
    croak "undefined argument" unless defined $_[0];

    my ($last, @list) = @_;

    return @list
      if $last > @list;

    return ()
      if $last <= 0;

    return @list[@list - $last .. $#list];
}

=head2 uniq_keep_first

    @unique_values = uniq_keep_first( @list )

C<uniq_keep_first()> returns all the unique elements in C<@list>,
without needing C<@list> to be sorted. Whenever duplicates are
encountered, the first occurance is the one that is kept.

For example:

    uniq_keep_first( 1, 2, 3, 2 ); # 1, 2, 3

=cut

sub uniq_keep_first {
    my %seen;
    return grep { $seen{$_}++ ? () : $_ } @_
}

=head2 uniq_keep_last

    @unique_values = uniq_keep_last( @list )

C<uniq_keep_last()> returns all the unique elements in C<@list>,
without needing C<@list> to be sorted. Whenever duplicates are
encountered, the last occurance is the one that is kept.

For example:

    uniq_keep_last( 1, 2, 3, 2 ); # 1, 3, 2

=cut

sub uniq_keep_last {
    my %seen = map { $_[$_] => $_ } 0 .. $#_; # $item => $last_index_seen_at
    return sort { $seen{$a} <=> $seen{$b} } keys %seen;
}

=head2 list_find

XXX

=cut

sub list_find { # XXX use List::MoreUtils::first_index() ???
    my $target = shift;

    my $ii = 0;
    for (@_) {
        return $ii
          if $_[$ii] eq $target;
        $ii ++;
    }
    return -1;
}

=head1 MATH FUNCTIONS (C<:math> or C<:maths>)

=head2 count_bits

XXX

=cut

sub count_bits {}

=head2 extrapolate, interpolate

    $mapped_value = extrapolate($value,
        $from_low, $from_high, $to_low, $to_high, $throw=undef)

C<interpolate()> is a synonym of C<extrapolate()>.

Re-maps a number from one range to another. That is, a C<$value> of
C<$from_low> would get mapped to C<$to_low> and a C<$value> of
C<$from_high> to C<$to_high>. A C<$value> between C<$from_low> and
C<$from_high> is mapped proportionately between C<$to_low> and
C<$to_high>.

If C<$value> is outside of the input range a C<value out of range>
error will be thrown if C<$throw> evaluates to true, and extrapolated
otherwise.

Based on the C function C<map()> provided by the Arduino platform
(L<https://www.arduino.cc/en/Reference/Map>).

=cut

sub extrapolate {
    croak sprintf "extrapolate() requires 5 or 6 arguments: %d given", scalar @_
      unless @_ == 5 || @_ == 6;
    my ($value, $from_low, $from_high, $to_low, $to_high, $throw) = @_;

    croak sprintf 'value out of range: "%s"', $value // 'undef'
      if $throw && ($value < $from_low || $value <= $from_high);

    return +($value - $from_low) * ($to_high - $to_low)
          / ($from_high - $from_low)                    + $to_low;
}
*interpolate = *interpolate = \&extrapolate; # avoid "used only once" warning

=head2 gcd

    $integer = gcd(@list)

Return the I<greatest common divider> of the integers in C<@list>.

=cut

sub gcd {
    my ($a, $b, @rest) = @_;

    return                         if @_ == 0;
    return $a                      if @_ == 1;
    return gcd(gcd($a, $b), @rest) if @_ >  2;

    return $b == 0 ? abs $a : gcd($b, $a % $b);
}

=head2 lcm

    $integer = lcm(@list)

Return the I<lowest common multiple> of the integers in C<@list>.

=cut

sub lcm {
    my ($a, $b, @rest) = @_;

    return                          if @_ == 0;
    return $a                       if @_ == 1;
    return abs($a*$b) / gcd($a, $b) if @_ == 2;
    return lcm(lcm($a, $b), @rest);
}

=head2 normal_cdf

    $p = normal_cdf($x, from_neginf => $bool)

I<cumulative distribution function> of the I<normal curve>. Returns
the probablility of a normally distributed random variable with mean 0
and standard deviation 1 falling between C<-$x> and C<+$x> standard
deviations of the mean. Or, when C<from_neginf> is true, the
probablility of that random variable being less than C<$x>. The
default value of C<from_neginf> is false.

=cut

sub normal_cdf {
    croak "invalid number of arguments"
      unless @_ == 1 || @_ == 3;
    my ($x, %opt) = @_;

    $opt{from_neginf} = 0 unless exists $opt{from_neginf};

    croak "invalid option"
      unless keys(%opt) == 1;

    $x = abs $x unless $opt{from_neginf};
    my $erf = POSIX::erf( $x / sqrt(2) );
    return $opt{from_neginf} ? 0.5 + $erf / 2 : $erf;
}

=head1 STRING FUNCTIONS (C<:string>)

=head2 is_in

XXX

=cut

sub is_in {}

=head2 ltrim

    ltrim()                           # case 1
    ltrim($string)                    # case 2
    ltrim(@list)                      # case 3
    $modified_string = ltrim()        # case 4
    $modified_string = ltrim($string) # case 5
    @modified_list   = ltrim(@list)   # case 6

C<ltrim()> removes all leading spaces from a scalar, or from each
element if passed a list.

If called in void context (the first three cases above), C<ltrim()>
changes C<$string> or C<@list> in-place. If no parameter is passed
(the first case above), C<$_> will be left-trimmed.

If called in scalar context (cases four and five) the original string
will not be changed and, instead, a modified string will be returned.

In the final case, C<ltrim()> will return a modified copy of each
element of C<@list>.

=cut

sub ltrim {
    if (@_ == 0) {
        s/^\s+//;
    }
}

=head2 timestamp

    $timestamp = timestamp()

XXX

=cut

sub timestamp {
    my ($sec, $min, $hour, $day, $mon, $year) = gmtime;
    $mon += 1;
    $year += 1900;
    return sprintf "%04d%02d%02d-%02d%02d%02d",
      $year, $mon, $day, $hour, $min, $sec;
}

1;

__END__

=head1 AUTHOR

Brian Greenfield, C<< <briang at cpan dot org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-briang-utils at
rt.cpan.org>XXX, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=BRIANG-Utils>XXX. I will
be notified, and then you'll automatically be notified of progress on
your bug as I make changes.

=head1 SOURCE CODE REPOSITORY

XXX

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc BRIANG::Utils

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=BRIANG-Utils>XXX

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/BRIANG-Utils>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/BRIANG-Utils>

=item * Search CPAN

L<http://search.cpan.org/dist/BRIANG-Utils/>

=back

=head1 ACKNOWLEDGEMENTS

=head1 LICENSE AND COPYRIGHT

Copyright 2016 Brian Greenfield.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
